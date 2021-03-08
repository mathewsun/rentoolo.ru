USE [Rentoolo]
GO

/****** Object:  Table [dbo].[ItemLikes]    Script Date: 04.11.2020 17:01:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ItemLikes](
	[Id] [bigint] NOT NULL,
	[ObjectType] [int] NOT NULL,
	[ObjectId] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO


