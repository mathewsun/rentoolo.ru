CREATE PROCEDURE  [dbo].[spGetWatchedByCookies]
@uid nvarchar(50)
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
	FROM [dbo].[WatchedByCookies] w
	LEFT JOIN [Adverts] a
	on w.[AdvertId] = a.[Id]
	where w.[UserCookiesId] = @uid
	ORDER BY CreatedFavorites DESC
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetWatchedByCookies] TO PUBLIC
    AS [dbo];