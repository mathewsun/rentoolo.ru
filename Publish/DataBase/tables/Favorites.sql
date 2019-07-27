CREATE TABLE [dbo].[Favorites](
	[Id] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AdvertId] [bigint] NOT NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Favorites] ADD  CONSTRAINT [DF_Favorites_Created]  DEFAULT (getdate()) FOR [Created]
GO

