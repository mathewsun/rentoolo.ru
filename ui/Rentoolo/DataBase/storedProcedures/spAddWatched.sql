CREATE PROCEDURE  [dbo].[spAddWatched]
@UserId uniqueidentifier, @advertId bigint
AS
BEGIN
    INSERT INTO Watched (UserId, AdvertId)
    VALUES (@UserId, @advertId)
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spAddWatched] TO PUBLIC
    AS [dbo];