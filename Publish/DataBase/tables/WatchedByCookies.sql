CREATE TABLE [dbo].[WatchedByCookies](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserCookiesId] [nvarchar](36) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_WatchedByCookies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WatchedByCookies] ADD  CONSTRAINT [DF_WatchedByCookies_Created]  DEFAULT (getdate()) FOR [Created]
GO


