CREATE PROCEDURE  [dbo].[spGetFavorites]
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
      ,a.[Position]
	FROM [dbo].[Favorites] f
	LEFT JOIN [Adverts] a
	on f.[AdvertId] = a.[Id]
	where f.[UserId] = @userId
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetFavorites] TO PUBLIC
    AS [dbo];