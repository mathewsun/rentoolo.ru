create PROCEDURE  [dbo].[spAddFavoritesAuctionsByCookies]
@uid nvarchar(36), @auctionId bigint
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM FavoritesAuctionsByCookies 
                   WHERE UserCookiesId = @uid
                   AND AuctionId = @auctionId)
   BEGIN
       INSERT INTO FavoritesAuctionsByCookies (UserCookiesId, AuctionId)
       VALUES (@uid, @auctionId)
   END
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[spAddFavoritesAuctionsByCookies] TO PUBLIC
    AS [dbo];