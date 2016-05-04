CREATE TABLE [dbo].[SQL_100_Full]
(
[TData] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPU] [int] NULL,
[Reads] [bigint] NULL,
[Writes] [bigint] NULL,
[Duration] [bigint] NULL,
[STime] [datetime] NULL,
[ETime] [datetime] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ncl_PM_100Full_ST_ETTD] ON [dbo].[SQL_100_Full] ([STime], [ETime]) INCLUDE ([TData]) ON [PRIMARY]
GO
