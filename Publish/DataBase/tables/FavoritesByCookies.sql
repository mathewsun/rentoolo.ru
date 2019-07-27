CREATE TABLE [dbo].[FavoritesByCookies](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FavoritesByCookies] ADD  CONSTRAINT [DF_FavoritesByCookies_Created]  DEFAULT (getdate()) FOR [Created]
GO