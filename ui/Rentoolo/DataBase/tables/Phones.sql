GO
/****** Object:  Table [dbo].[Phones]    Script Date: 16.12.2019 2:16:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [nvarchar](50) NOT NULL,
	[Pwd] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Blocked] [bit] NOT NULL,
	[LastActive] [datetime] NOT NULL,
	[Balance] [float] NOT NULL,
	[WhenHistoryChecked] [datetime] NOT NULL,
	[BalanceUpdatePerMonth] [float] NOT NULL,
	[BalanceUpdatePerMonthUpdateDate] [datetime] NOT NULL,
	[IdentificateStatus] [int] NOT NULL,
	[Commision] [bit] NOT NULL,
 CONSTRAINT [PK_Phones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_Blocked]  DEFAULT ((0)) FOR [Blocked]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_LastActive]  DEFAULT (getdate()) FOR [LastActive]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_Balance]  DEFAULT ((0)) FOR [Balance]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_WhenHistoryChecked]  DEFAULT (getdate()) FOR [WhenHistoryChecked]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_BalanceUpdatePerMonth]  DEFAULT ((0)) FOR [BalanceUpdatePerMonth]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_BalanceUpdatePerMonthUpdateDate]  DEFAULT (getdate()) FOR [BalanceUpdatePerMonthUpdateDate]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_IdentificateStatus]  DEFAULT ((1)) FOR [IdentificateStatus]
GO
ALTER TABLE [dbo].[Phones] ADD  CONSTRAINT [DF_Phones_Commision]  DEFAULT ((0)) FOR [Commision]
GO
