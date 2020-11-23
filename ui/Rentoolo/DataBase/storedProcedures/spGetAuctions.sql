ALTER PROCEDURE  [dbo].[spGetUserAuctions]
@UserId uniqueidentifier
AS
BEGIN
	SELECT 
	   a.[Id]
      ,a.[Name] AuctionOwnerName 
      ,a.[StartPrice] 
      ,a.[Created] CreationDate
	  ,u.[UserName] 
	FROM [Auctions] as a
	LEFT JOIN [Users] as u
	on a.[UserId] = u.[UserId]
	where a.[UserId] = @userId
	ORDER BY a.Id DESC
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetUserAuctions] TO PUBLIC
    AS [dbo];
	