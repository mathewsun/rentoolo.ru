CREATE PROCEDURE  [dbo].[spGetComments]
@objectId bigint, @userId uniqueidentifier
AS
BEGIN
	SELECT [Id]
      ,[UserId]
      ,[AdvertId]
      ,[Comment]
      ,[Date]
      ,[Likes]
      ,[DisLikes]
      ,[Type]
  FROM [Comments]
	where [UserId] = @userId
	ORDER BY [Date] ASC
END
GO
