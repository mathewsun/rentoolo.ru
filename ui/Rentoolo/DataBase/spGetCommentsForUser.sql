USE [Rentoolo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetCommentsForUser]
(@userId uniqueidentifier, @advertId int)
AS
BEGIN
	SELECT [Id]
      ,[UserId]
      ,[AdvertId]
      ,[Comment]
      ,[Date]
	  ,(SELECT COUNT(*) FROM [dbo].[Likes] WHERE CommentId = Id) AS Likes
	  ,(SELECT COUNT(*) FROM [dbo].[DisLikes] WHERE CommentId = Id) AS DisLikes

	  ,CONVERT(BIT, (CASE when  EXISTS (SELECT * FROM [dbo].[DisLikes] 
	  WHERE CommentId = Id AND UserId = @userId) then 1 ELSE 0 END) ) AS HaveDisLiked

	  ,CONVERT(BIT, (CASE when  EXISTS (SELECT * FROM [dbo].[Likes] 
	  WHERE CommentId = Id AND UserId = @userId) then 1 ELSE 0 END) ) AS HaveLiked

      ,[Type]
  FROM [Comments]
	where [AdvertId] = @advertId
	ORDER BY [Date] ASC
END