CREATE TABLE [dbo].[Business](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Header] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Cost] [float] NULL,
	[NoCost] [bit] NOT NULL,
	[PaybackPeriod] [float] NULL,
	[MonthlyIncome] [float] NULL,
 CONSTRAINT [PK_Business] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Business] ADD  CONSTRAINT [DF_Business_NoCost]  DEFAULT ((0)) FOR [NoCost]
GO

