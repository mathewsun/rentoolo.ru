ALTER PROCEDURE  [dbo].[spGetFavorites]
@userId uniqueidentifier
AS
BEGIN
	SELECT f.[Id]
      ,f.[AdvertId]
      ,f.[Created] CreatedFavorites
	  ,a.[Category]
	  ,a.[Name]
      ,a.[Description]
      ,a.[Created] CreatedAdverts
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
	  ,a.[ImgUrls]
      ,cast(a.[Position] as varchar(max)) PositionString
	FROM [dbo].[Favorites] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[UserId] = @userId
	ORDER BY CreatedFavorites DESC
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetFavorites] TO PUBLIC
    AS [dbo];