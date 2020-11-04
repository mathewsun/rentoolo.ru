USE [Rentoolo]
GO

/****** Object:  Table [dbo].[Users]    Script Date: 21.09.2020 20:24:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
	[Pwd] [nvarchar](max) NULL,
	[PublicId] [int] NOT NULL,
	[Communication] [nvarchar](max) NULL,
	[ReffAdd] [float] NOT NULL,
	[LastGeoposition] [nvarchar](51) NULL,
	[Language] [nvarchar](10) NULL,
	[Sex] [int] NULL,
	[Interests] [nvarchar](max) NULL,
	[WorkPlace] [nvarchar](max) NULL,
	[AboutUser] [nvarchar](max) NULL,
	[BirthDay] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_PublicId]  DEFAULT ((0)) FOR [PublicId]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_ReffAdd]  DEFAULT ((0)) FOR [ReffAdd]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [UserApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [UserApplication]
GO


