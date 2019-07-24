CREATE PROCEDURE  [dbo].[spGetFavorites]
@uid nvarchar(50)
AS
BEGIN
	select id
	from FavoritesByCookies f
	where f.Value = @uid
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetFavorites] TO PUBLIC
    AS [dbo];