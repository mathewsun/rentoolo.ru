CREATE TABLE [dbo].[FavoritesByCookies](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserCookiesId] [nvarchar](50) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_FavoritesByCookies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FavoritesByCookies] ADD  CONSTRAINT [DF_FavoritesByCookies_Created]  DEFAULT (getdate()) FOR [Created]
GO

