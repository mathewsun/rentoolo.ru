USE [Rentoolo]
GO
/****** Object:  StoredProcedure [dbo].[spGetComplaintsBySender]    Script Date: 28.10.2020 11:03:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[spGetComplaintsBySender]
(@userId uniqueidentifier)
AS
BEGIN


SELECT cpts.[Id]
      ,[Message]
      ,[ComplaintType]
      ,[ObjectId]
      ,[ObjectType]
      ,[UserSender]
      ,[UserRecipier]
      ,[Data]
	  ,usrs.UserName AS UserSenderName
	  , (SELECT FIRST_VALUE(UserName) OVER(ORDER BY Id) FROM [dbo].[Users] WHERE UserId = UserRecipier) AS UserRecipierName
  FROM [dbo].[Complaints] as cpts 
  LEFT JOIN [dbo].[Users] as usrs ON( cpts.UserSender = usrs.UserId) WHERE cpts.UserSender = @userId 

END

