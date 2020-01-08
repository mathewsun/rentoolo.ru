CREATE PROCEDURE  [dbo].[spGetWatched]
@userId uniqueidentifier
AS
BEGIN
	SELECT w.[Id]
      ,w.[AdvertId]
      ,w.[Created] CreatedFavorites
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
	FROM [dbo].[Watched] w
	LEFT JOIN [Adverts] a
	on w.[AdvertId] = a.[Id]
	where w.[UserId] = @userId
	ORDER BY CreatedFavorites DESC
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetWatched] TO PUBLIC
    AS [dbo];