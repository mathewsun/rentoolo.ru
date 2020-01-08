CREATE PROCEDURE  [dbo].[spAddWatchedByCookies]
@uid nvarchar(36), @advertId bigint
AS
BEGIN
    INSERT INTO WatchedByCookies (UserId, AdvertId)
    VALUES (@uid, @advertId)
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spAddWatchedByCookies] TO PUBLIC
    AS [dbo];