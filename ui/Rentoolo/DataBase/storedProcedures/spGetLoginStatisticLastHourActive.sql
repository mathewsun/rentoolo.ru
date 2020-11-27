CREATE PROCEDURE  [dbo].[spGetLoginStatisticLastHourActive]
AS
BEGIN
	DECLARE @Result int;
    SET @Result =
	(SELECT Count(distinct [UserName])
	FROM [LoginStatistics]
	where [WhenLastDate] > DATEADD(HOUR, -1, GETDATE()) 
	 );
     RETURN(@Result);
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetLoginStatisticLastHourActive] TO PUBLIC
    AS [dbo];