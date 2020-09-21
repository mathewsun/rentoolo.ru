USE [Rentoolo]
GO

/****** Object:  Table [dbo].[TenderRequest]    Script Date: 21.09.2020 19:50:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TenderRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[ProviderId] [uniqueidentifier] NOT NULL,
	[ProviderName] [nvarchar](50) NOT NULL,
	[Cost] [int] NOT NULL,
	[CustomerId] [uniqueidentifier] NOT NULL,
	[DateStart] [datetime] NULL,
	[DateCompleted] [datetime] NULL,
	[DateDelivered] [datetime] NULL,
	[DateWin] [datetime] NULL,
	[TenderId] [int] NOT NULL,
 CONSTRAINT [PK_TenderRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TenderRequest] ADD  CONSTRAINT [DF_TenderRequest_Cost]  DEFAULT ((0)) FOR [Cost]
GO

ALTER TABLE [dbo].[TenderRequest] ADD  CONSTRAINT [DF_TenderRequest_DateStart]  DEFAULT (getdate()) FOR [DateStart]
GO


