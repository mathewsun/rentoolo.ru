USE [Rentoolo]
GO

/****** Object:  Table [dbo].[TokensBuying]    Script Date: 26.09.2019 21:16:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TokensBuying](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Count] [nchar](10) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CostOneToken] [float] NOT NULL,
	[FullCost] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TokensBuying] ADD  CONSTRAINT [DF_TokensBuying_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO


