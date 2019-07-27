CREATE TABLE [dbo].[Adverts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Category] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedUserId] [uniqueidentifier] NOT NULL,
	[Price] [float] NOT NULL,
	[Address] [nvarchar](150) NULL,
	[Phone] [nvarchar](50) NULL,
	[MessageType] [int] NOT NULL,
	[Position] [geography] NULL,
 CONSTRAINT [PK_Adverts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_CreateDate]  DEFAULT (getdate()) FOR [Created]
GO

ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_Price]  DEFAULT ((0)) FOR [Price]
GO

ALTER TABLE [dbo].[Adverts] ADD  CONSTRAINT [DF_Adverts_MessageType]  DEFAULT ((1)) FOR [MessageType]
GO


