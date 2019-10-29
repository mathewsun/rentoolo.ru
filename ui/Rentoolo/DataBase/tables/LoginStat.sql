CREATE TABLE [dbo].[LoginStat](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[UserId] [uniqueidentifier] NULL,
	[Ip] [varchar](48) NULL,
	[WhenDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LoginStat] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LoginStat] ADD  CONSTRAINT [DF_LoginStat_WhenDate]  DEFAULT (getdate()) FOR [WhenDate]
GO


