SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[pu_restoreinstance] (@fp1 varchar(50), @fp2 varchar(50))
as
---- for post restore
--select 
--    'use ' + name + CHAR(10) + 'go'
--    + CHAR(10) +
--    'if exists (select 1 from sysusers where name = ''samb01-accumupdate'')
--	   begin
--    		  exec sp_change_users_login update_one, [samb01-accumupdate],[samb01-accumupdate];
--	   end;' + CHAR(10) +'go'
--    + CHAR(10) + 
--    'sp_changedbowner ''sa''' + CHAR(10) + 'go'
--    + CHAR(10) +
--    'alter database ' + name + ' set trustworthy on;' + CHAR(10) + 'go'
--from 
--    sys.databases where name like 'CCH_%';
    


declare @DBName sysname, 
	   @FilePath1 varchar(50),
	   @FilePath2 varchar(50)
set @DBName = DB_NAME();

set @FilePath1 = @fp1
set @FilePath2 = @fp2
--set @FilePath1 = 'g:\sql\sprintcleanup\alpha2_';
--set @FilePath2 = '_20160202.bak';


-- for restore
declare 
	   @MDFPath varchar(150),
	   @NDFPath varchar(150),
	   @LDFPath varchar(150),
	   @FTCPath varchar(150),
	   @SQL varchar(max)

--set	   @DBName = DB_NAME();
--set	   @FilePath1 = ''
--set	   @FilePath2 = '_20150301.bak'	   

if DB_NAME() <> 'cch_referencedata'
begin
	if exists(select * from sysfiles where name = 'data')
		begin
			select @MDFPath = filename from sysfiles where name = 'data';
		end;

	if exists(select 1 from sysfiles where name = 'index')
		begin
			select @NDFPath = filename from sysfiles where name = 'index';
		end;

	if exists(select 1 from sysfiles where name = 'log')
		begin
			select @LDFPath = filename from sysfiles where name = 'log';
		end;

	if exists(select 1 from sysfiles where name = 'Fulltext_FG')
		begin
			select @FTCPath = filename from sysfiles where name = 'Fulltext_FG';
		end;		
end;

-- handle refdata
if DB_NAME() = 'cch_referencedata'
begin
	if exists(select 1 from sysfiles where name = 'CCH_ReferenceData')
		begin
			select @MDFPath = filename from sysfiles where name = 'CCH_ReferenceData';
		end;

	if exists(select 1 from sysfiles where name = 'CCH_ReferenceData_IX')
		begin
			select @NDFPath = filename from sysfiles where name = 'CCH_ReferenceData_IX';
		end;

	if exists(select 1 from sysfiles where name = 'CCH_ReferenceData_log')
		begin
			select @LDFPath = filename from sysfiles where name = 'CCH_ReferenceData_log';
		end;

	if exists(select 1 from sysfiles where name = 'Fulltext_FG')
		begin
			select @FTCPath = filename from sysfiles where name = 'Fulltext_FG';
		end;
end;


--sp_helpdb cch_referencedata

--select 	   @MDFPath ,
--	   @NDFPath ,
--	   @LDFPath ,
--	   @FTCPath 
if DB_NAME() <> 'cch_referencedata'
begin
	set @SQL = 

	'exec dba.dbo.p_kill ''' + DB_NAME() + '''' + CHAR(10) + 'go' + CHAR(10) + 
	'RESTORE DATABASE  ' + @DBName + CHAR(10) +
	'FROM  DISK = N''' + @FilePath1 + @DBName + @FilePath2 + '''' + CHAR(10) + 
	'WITH FILE = 1,'  + CHAR(10) + 
	'MOVE N''data'' TO N''' + @MDFPath + ''','  + CHAR(10) + 
	'MOVE N''log'' TO N''' + @LDFPath + ''','  + CHAR(10) +  
	case when isnull(@NDFPath,'') <> '' then 'MOVE N''index'' TO N''' + @NDFPath + ''',' else '' end + 
	case when isnull(@FTCPath,'') <> '' then 'MOVE N''Fulltext_FG'' TO N''' + @FTCPath + ''',' else ''  end  + CHAR(10) + 
	'NOUNLOAD,  REPLACE,  STATS = 10;' + char(10) + 'go'
	print @SQL 
end;


if DB_NAME() = 'cch_referencedata'
begin
	set @SQL = 

	'exec dba.dbo.p_kill ''' + DB_NAME() + '''' + CHAR(10) + 'go' + CHAR(10) + 
	'RESTORE DATABASE  ' + @DBName + CHAR(10) +
	'FROM  DISK = N''' + @FilePath1 + @DBName + @FilePath2 + '''' + CHAR(10) + 
	'WITH FILE = 1,'  + CHAR(10) + 
	'MOVE N''CCH_ReferenceData'' TO N''' + @MDFPath + ''','  + CHAR(10) + 
	'MOVE N''CCH_ReferenceData_log'' TO N''' + @LDFPath + ''','  + CHAR(10) +  
	case when isnull(@NDFPath,'') <> '' then 'MOVE N''CCH_ReferenceData_IX'' TO N''' + @NDFPath + ''',' else '' end + 
	case when isnull(@FTCPath,'') <> '' then 'MOVE N''Fulltext_FG'' TO N''' + @FTCPath + ''',' else ''  end  + CHAR(10) + 
	'NOUNLOAD,  REPLACE,  STATS = 10;' + char(10) + 'go'
	print @SQL 
end;
--exec dba.dbo.p_kill 'CCH_HamiltonWeb'
--go
--RESTORE DATABASE  CCH_HamiltonWeb
--FROM  DISK = N'g:\sql\sprintcleanup\alpha2_CCH_HamiltonWeb_20151202.bak'
--WITH FILE = 1,
--MOVE N'data' TO N'H:\SQL\ALPHA\Data\CCH_HamiltonWeb.mdf',
--MOVE N'log' TO N'I:\SQL\ALPHA\Log\CCH_HamiltonWeb_1.ldf',
--MOVE N'Fulltext_FG' TO N'N:\SQL\FT_Index\CCH_HamiltonWeb_Fulltext_FG.ndf',
--NOUNLOAD,  REPLACE,  STATS = 10;
--go

--if (select COUNT(*) from sysfiles) = 3
--    begin    		  
--	   set @SQL =
--	   'RESTORE DATABASE  ' + @DBName + CHAR(10) +
--	   'FROM  DISK = N''' + @FilePath1 + @DBName + @FilePath2 + '''
--	   WITH  FILE = 1,  
--	   MOVE N''data'' TO N''' + @MDFPath + ''',  
--	   MOVE N''index'' TO N''' + @NDFPath + ''',
--	   MOVE N''log'' TO N''' + @LDFPath + ''',   
--	   NOUNLOAD,  REPLACE,  STATS = 10;' + char(10) + 'go'
--    end
--else    
--    begin    		  
--	   set @SQL =
--	   'RESTORE DATABASE  ' + @DBName + CHAR(10) +
--	   'FROM  DISK = N''' + @FilePath1 + @DBName + @FilePath2 + '''
--	   WITH  FILE = 1,  
--	   MOVE N''data'' TO N''' + @MDFPath + ''',  
--	   MOVE N''log'' TO N''' + @LDFPath + ''',   
--	   NOUNLOAD,  REPLACE,  STATS = 10;' + char(10) + 'go'
--    end


--select @SQL

GO
