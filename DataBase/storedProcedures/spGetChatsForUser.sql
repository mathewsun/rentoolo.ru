USE [Rentoolo]
GO
/****** Object:  StoredProcedure [dbo].[spGetChats]    Script Date: 07.10.2020 20:18:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spGetChatsForUser]
(@userId uniqueidentifier)
AS
BEGIN


SELECT chats.Id
	, (CASE WHEN chats.ChatType = 1 THEN ( 
	
	SELECT users.UserName FROM [dbo].ChatUsers AS chatUsers 
	LEFT JOIN [dbo].Users AS users 
	ON (users.UserId = chatUsers.UserId) 
	WHERE chatUsers.UserId != @userId AND chatUsers.ChatId = chats.Id
	
	) ELSE chats.ChatName END ) AS ChatName


FROM [dbo].[Chats] AS chats
LEFT JOIN [dbo].ChatUsers AS chatUsers ON (chatUsers.ChatId = chats.Id) WHERE chatUsers.UserId = @userId

END

