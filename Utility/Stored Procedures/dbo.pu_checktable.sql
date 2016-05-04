SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[pu_checktable] (@db sysname, @tbl sysname)
as

declare @sql  varchar(500)--, @tbl sysname, @db sysname
--set @db = 'cch_referencedata'
--set @tbl = 'singlesearch_floc'

set @sql = 'use ' + @db + ';' + char(10) + 
'SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID(db_name()), OBJECT_ID(N''' + @tbl + '''), NULL, NULL , ''DETAILED'');' + char(10) + char(10) + 
'ALTER INDEX ALL ON ''' + @tbl + ''' REBUILD WITH (ONLINE = OFF);
UPDATE STATISTICS ''' + @tbl + ''' WITH FULLSCAN,COLUMNS;'

select @sql 
GO
