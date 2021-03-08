USE [Rentoolo]
GO

/****** Object:  Table [dbo].[ExchangeProducts]    Script Date: 22.11.2020 22:47:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ExchangeProducts](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[WantedObject] [nvarchar](50) NULL,
	[Header] [nvarchar](50) NULL,
 CONSTRAINT [PK_ExchangeProducts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


