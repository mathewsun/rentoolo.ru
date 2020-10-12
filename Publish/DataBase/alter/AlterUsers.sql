USE [Rentoolo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE dbo.Users ADD Sex int NULL, Interests nvarchar(MAX) NULL,
			WorkPlace nvarchar(MAX) NULL, AboutUser nvarchar(MAX) NULL ;