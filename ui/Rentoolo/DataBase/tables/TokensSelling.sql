USE [Rentoolo]
GO

/****** Object:  Table [dbo].[TokensSelling]    Script Date: 26.09.2019 21:15:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TokensSelling](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Count] [nchar](10) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CostOneToken] [float] NOT NULL,
	[FullCost] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TokensSelling] ADD  CONSTRAINT [DF_TokensSelling_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO


