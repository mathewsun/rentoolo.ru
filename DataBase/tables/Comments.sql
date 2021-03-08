USE [Rentoolo]
GO

/****** Object:  Table [dbo].[Comments]    Script Date: 21.09.2020 19:49:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](max) NOT NULL,
	[AdvertId] [int] NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Likes] [int] NOT NULL,
	[DisLikes] [int] NOT NULL,
	[Type] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_Likes]  DEFAULT ((0)) FOR [Likes]
GO

ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_DisLikes]  DEFAULT ((0)) FOR [DisLikes]
GO

ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_Type]  DEFAULT ((1)) FOR [Type]
GO


