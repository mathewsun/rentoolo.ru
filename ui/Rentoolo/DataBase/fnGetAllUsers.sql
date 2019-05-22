ALTER FUNCTION dbo.fnGetAllUsers ()
RETURNS table
AS
RETURN 
(
	SELECT 	u.[UserId]
		,u.[UserName]
		,u.[LastActivityDate]
		,u.[Pwd]
		,u.[PublicId]
		,u.[Communication]
		,m.[CreateDate]
		,m.[Email]
	FROM [Users] u
	LEFT JOIN [Memberships] m
	ON u.[UserId] = m.[UserId]
);
GO