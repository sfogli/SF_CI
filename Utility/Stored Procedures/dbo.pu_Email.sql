SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[pu_Email]
(@rcp varchar(250), @sub varchar(250))
as

exec [msdb].dbo.sp_send_dbmail 
	@profile_name = 'clearcosthealth',
	@recipients = @rcp,		  
	@subject = @sub;

GO
