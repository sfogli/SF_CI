CREATE TABLE [dbo].[Last_Restart]
(
[Name] [sys].[sysname] NOT NULL,
[Owner] [sys].[sysname] NOT NULL,
[Created] [date] NOT NULL,
[Status] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Compatibility_Level] [int] NOT NULL,
[RestartDate] [datetime] NULL
) ON [PRIMARY]
GO
