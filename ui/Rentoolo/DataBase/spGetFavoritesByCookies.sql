ALTER PROCEDURE  [dbo].[spGetFavoritesByCookies]
@uid nvarchar(50)
AS
BEGIN
	SELECT f.[Id]
      ,f.[AdvertId]
      ,f.[Created] CreatedAdverts
	  ,a.[Category]
	  ,a.[Name]
      ,a.[Description]
      ,a.[Created] CreatedFavorites
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
      ,a.[Position]
	FROM [dbo].[FavoritesByCookies] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[Value] = @uid
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetFavoritesByCookies] TO PUBLIC
    AS [dbo];