SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[p_Optimize]
(@dbname sysname)
as 


declare @sql varchar(max)
set @sql = 
'use ' + @dbname + ';' + CHAR(10) 
+ 'dbcc checkdb with physical_only;' + char(10)
+ 'EXEC SP_MSForEachTable ''ALTER INDEX ALL ON ? REBUILD WITH (ONLINE = OFF)'';' + char(10)
+ 'EXEC SP_MSForEachTable ''UPDATE STATISTICS ? WITH FULLSCAN,COLUMNS'';' + char(10) 
+ 'DBCC UPDATEUSAGE (0) WITH NO_INFOMSGS;' + char(10) 
--+ 'EXEC p_RefreshFTC;' + CHAR(10)
exec (@sql);
--print @sql

GO
