CREATE TABLE [dbo].[employers]
(
[EmployerID] [int] NOT NULL IDENTITY(1, 1),
[EmployerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConnectionString] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Insurer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RXProvider] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShowYourCostColumn] [bit] NULL,
[ContentID] [uniqueidentifier] NULL,
[InsurerOrgName_270] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurerPrimaryID_270] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurerID_Type_270] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsurerIP_270] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Username_270] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password_270] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberID_Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainEmployerID] [int] NULL,
[EmployerDBName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
