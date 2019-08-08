ALTER PROCEDURE  [dbo].[spGetUserAdverts]
@UserId uniqueidentifier
AS
BEGIN
	SELECT a.[Id]
      ,a.[Category]
      ,a.[Name]
      ,a.[Description]
      ,a.[Created]
      ,a.[CreatedUserId]
      ,a.[Price]
      ,a.[Address]
      ,a.[Phone]
      ,a.[MessageType]
      ,a.[Position]
	FROM [Adverts] a
	WHERE a.[CreatedUserId] = @UserId
	ORDER BY a.[Created] DESC
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetUserAdverts] TO PUBLIC
    AS [dbo];