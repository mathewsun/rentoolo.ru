CREATE PROCEDURE  [dbo].[spAddFavoritesAuctions]
@UserId uniqueidentifier, @AuctionId bigint
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM FavoritesAuctions 
                   WHERE UserId = @UserId
                   AND AuctionId = @AuctionId)
   BEGIN
       INSERT INTO FavoritesAuctions (UserId, AuctionId)
       VALUES (@UserId, @AuctionId)
   END
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spAddFavorites] TO PUBLIC
    AS [dbo];