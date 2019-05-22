CREATE PROCEDURE  [dbo].[spGetLoginStatisticLastDayActive]
AS
BEGIN
	DECLARE @Result int;
    SET @Result =
	(SELECT Count(distinct [UserName])
	FROM [LoginStatistics]
	where [WhenLastDate] > DATEADD(DAY, -1, GETDATE()) 
	 );
     RETURN(@Result);
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetLoginStatisticLastDayActive] TO PUBLIC
    AS [dbo];