USE [Rentoolo]
GO

/****** Object:  Table [dbo].[ItemDislikes]    Script Date: 04.11.2020 17:00:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ItemDislikes](
	[Id] [bigint] NOT NULL,
	[ObjectType] [int] NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO


