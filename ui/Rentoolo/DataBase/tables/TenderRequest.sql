SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TenderRequest](
	[Id] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[ProviderId] [int] NOT NULL,
	[ProviderName] [nvarchar](50) NOT NULL,
	[Cost] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[DateStart] [datetime] NOT NULL,
	[DateCompleted] [datetime] NULL,
	[DateDelivered] [datetime] NULL,
 CONSTRAINT [PK_TenderRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TenderRequest] ADD  CONSTRAINT [DF_TenderRequest_Cost]  DEFAULT ((0)) FOR [Cost]
GO

ALTER TABLE [dbo].[TenderRequest] ADD  CONSTRAINT [DF_TenderRequest_DateStart]  DEFAULT (getdate()) FOR [DateStart]
GO


