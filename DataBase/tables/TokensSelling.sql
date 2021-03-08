USE [Rentoolo]
GO

/****** Object:  Table [dbo].[TokensSelling]    Script Date: 12.10.2019 21:18:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TokensSelling](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Count] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CostOneToken] [float] NOT NULL,
	[FullCost] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TokensSelling] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TokensSelling] ADD  CONSTRAINT [DF_TokensSelling_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO


