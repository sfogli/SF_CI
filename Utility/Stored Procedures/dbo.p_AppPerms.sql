SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
 create procedure [dbo].[p_AppPerms] (@action bit = 0)

 as


set nocount on;
declare @dbname sysname,
	   @c int,
	   @m int,
	   @sql varchar(max) = '';
	   

declare @db table (id smallint identity(1,1), dbname sysname)

insert into @db (dbname) 
select distinct employerdbname 
from cch_frontend2.dbo.employers e join sys.databases sd 
on e.employerdbname = sd.name
order by 1;

insert into @db(dbname)
values ( 'cch_frontend2'),
	('cch_referencedata'),
	('msdb');

select  @c = MIN(id),
	   @m = MAX(id)
from	   @db;


	   
while   @c < = @m
    begin
    select  @dbname = dbname 
    from	  @db
    where	  id = @c;

if @dbname <> 'msdb'
	begin    
		set @sql = 
	'use ' + @dbname + ';' + CHAR(10) 
	+ 
	'if not exists (select 1 from sys.sysusers where name = ''samb01sa'')
	begin
		CREATE USER samb01sa FOR LOGIN samb01sa;
	end;
	EXEC sp_addrolemember ''db_executor'', ''samb01sa'';
	EXEC sp_addrolemember ''db_datareader'', ''samb01sa'';
	EXEC sp_addrolemember ''db_datawriter'', ''samb01sa'';' + char(10)
	end
else 

begin    
    set @sql = 
'use ' + @dbname + ';' + CHAR(10) 
+ 
'if not exists (select 1 from sys.sysusers where name = ''samb01sa'')
begin
	CREATE USER samb01sa FOR LOGIN samb01sa;
end;
EXEC sp_addrolemember ''databasemailuserrole'', ''samb01sa'';
EXEC sp_addrolemember ''db_datareader'', ''samb01sa'';
EXEC sp_addrolemember ''db_datawriter'', ''samb01sa'';' + char(10)
end


if @action = 1
	begin
		exec (@sql);
	end;
else
	begin
		print @sql
	end;
    
set @c = @c + 1;
    
set @sql = ''

end;






GO
