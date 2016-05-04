SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[pu_AppPerms]
(@login sysname ,
@action bit = 0)
as


--DECLARE @action bit = 0 
--declare @login sysname
--set @login  = 'CCH\SVC_MPWAPIDev'
/*

exec pu_AppPerms @login = 'CCH\SVC_MPWAPIDev', @action = 0;



*/

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
	'if not exists (select 1 from sys.sysusers where name = ''' + @login + ''')
	begin
		CREATE USER ['+ @login + '] FOR LOGIN [' + @login + '];
	end;
	ALTER ROLE [db_datareader] ADD MEMBER ['+ @login +'];
	ALTER ROLE [db_executor] ADD MEMBER [' +@login +'];
	ALTER ROLE [db_datawriter] ADD MEMBER [' +@login +'];' + char(10)
	end
else 

begin    
    set @sql = 
'use ' + @dbname + ';' + CHAR(10) 
+ 
'if not exists (select 1 from sys.sysusers where name = '''+ @login +''')
begin
	CREATE USER [' +@login +'] FOR LOGIN ['+@login+'];
end;
ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER  ['+ @login +'];
ALTER ROLE [databasemailuserrole] ADD MEMBER  ['+ @login +'];
ALTER ROLE [db_datareader] ADD MEMBER ['+ @login +'];
ALTER ROLE [db_datawriter] ADD MEMBER ['+ @login +'];' + char(10)
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
