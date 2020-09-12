SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Tenders](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [ntext] NULL,
	[UserOwnerId] [int] NOT NULL,
	[Cost] [float] NOT NULL,
	[ImgUrls] [nvarchar](max) NULL,
	[Status] [nchar](30) NULL,
	[Created] [datetime] NOT NULL,
	[CurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_Tenders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_Cost]  DEFAULT ((0)) FOR [Cost]
GO

ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_Created]  DEFAULT (getdate()) FOR [Created]
GO

ALTER TABLE [dbo].[Tenders] ADD  CONSTRAINT [DF_Tenders_CurrencyId]  DEFAULT ((1)) FOR [CurrencyId]
GO