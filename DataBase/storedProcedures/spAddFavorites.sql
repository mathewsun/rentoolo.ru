CREATE PROCEDURE  [dbo].[spAddFavorites]
@UserId uniqueidentifier, @advertId bigint
AS
BEGIN
   IF NOT EXISTS (SELECT * FROM Favorites 
                   WHERE UserId = @UserId
                   AND AdvertId = @advertId)
   BEGIN
       INSERT INTO Favorites (UserId, AdvertId)
       VALUES (@UserId, @advertId)
   END
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spAddFavorites] TO PUBLIC
    AS [dbo];