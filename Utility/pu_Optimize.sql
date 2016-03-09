USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[pu_Optimize]    Script Date: 3/9/2016 4:12:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pu_Optimize]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pu_Optimize]
GO

/****** Object:  StoredProcedure [dbo].[pu_Optimize]    Script Date: 3/9/2016 4:12:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pu_Optimize]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[pu_Optimize] AS' 
END
GO



ALTER procedure [dbo].[pu_Optimize] (@db sysname, @action tinyint = 1, @tbl sysname = '')

/************************************************************************
2015-11-06 SF
Utility sproc to optimize a db.

@action values:
1 = all actions (default) 
2 = index rebuild only
3 = update stats only
4 = index and stats only
5 = index and stats for targeted table

eg:
exec pu_Optimize @db = 'cch_starbucksweb', @action = 1, @tbl = 'servicepricing';

************************************************************************/
as

If @action = 5 and @tbl = ''
begin
	print 'Please specify a table or change action value.'
	return
end;


declare @sql varchar(2000),
@1 varchar(250),
@2 varchar(250),
@3 varchar(250),
@4 varchar(250);
set @sql = 
'use ' + @db + ';' + CHAR(10) 

If @action = 1
begin
set @sql = @sql
+ 'dbcc checkdb with physical_only;' + char(10)
+ 'EXEC SP_MSForEachTable ''ALTER INDEX ALL ON ? REBUILD WITH (ONLINE = OFF)'';' + char(10)
+ 'EXEC SP_MSForEachTable ''UPDATE STATISTICS ? WITH FULLSCAN,COLUMNS'';' + char(10) 
+ 'DBCC UPDATEUSAGE (0) WITH NO_INFOMSGS;' + char(10) 
end;

If @action = 2
begin
set @sql = @sql
+ 'EXEC SP_MSForEachTable ''ALTER INDEX ALL ON ? REBUILD WITH (ONLINE = OFF)'';' + char(10)
end;

If @action = 3
begin
set @sql = @sql
+ 'EXEC SP_MSForEachTable ''UPDATE STATISTICS ? WITH FULLSCAN,COLUMNS'';' + char(10) 
end;

If @action = 4
begin
set @sql = @sql
+ 'EXEC SP_MSForEachTable ''ALTER INDEX ALL ON ? REBUILD WITH (ONLINE = OFF)'';' + char(10)
+ 'EXEC SP_MSForEachTable ''UPDATE STATISTICS ? WITH FULLSCAN,COLUMNS'';' + char(10) 
end;

If @action = 5
begin
set @sql = @sql +
+ 'ALTER INDEX ALL ON ' + @tbl + ' REBUILD WITH (ONLINE = OFF);' + char(10)
+ 'UPDATE STATISTICS ' + @tbl + ' WITH FULLSCAN,COLUMNS;' +char(10)
end

exec (@sql);


GO


