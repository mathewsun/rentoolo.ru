CREATE PROCEDURE  [dbo].[spAddFavoritesByCookies]
@uid nvarchar(36), @advertId bigint
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM FavoritesByCookies 
                   WHERE UserCookiesId = @uid
                   AND AdvertId = @advertId)
   BEGIN
       INSERT INTO FavoritesByCookies (UserCookiesId, AdvertId)
       VALUES (@uid, @advertId)
   END
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spAddFavoritesByCookies] TO PUBLIC
    AS [dbo];