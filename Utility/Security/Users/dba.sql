IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'dba')
CREATE LOGIN [dba] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [dba] FOR LOGIN [dba]
GO
