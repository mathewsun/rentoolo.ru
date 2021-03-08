CREATE TABLE [dbo].[CashOuts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Value] [float] NOT NULL,
	[WhenDate] [datetime] NOT NULL,
	[Sposob] [nvarchar](max) NOT NULL,
	[WhenAdminEvent] [datetime] NULL,
	[State] [int] NOT NULL,
	[Number] [nvarchar](max) NULL,
	[Comment] [nvarchar](max) NULL,
	[Type] [int] NOT NULL,
	[PaymentNumber] [nvarchar](50) NULL,
	[Result] [int] NOT NULL,
 CONSTRAINT [PK_CashOuts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO

ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_Status]  DEFAULT ((1)) FOR [State]
GO

ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_Type]  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [dbo].[CashOuts] ADD  CONSTRAINT [DF_CashOuts_Result]  DEFAULT ((1)) FOR [Result]
GO