CREATE PROCEDURE  [dbo].[spGetTokenCostToday]
AS
BEGIN
	SELECT [Id]
      ,[Value]
      ,[Date]
  FROM [Rentoolo].[dbo].[TokensCost]
  WHERE CONVERT(date, [Date]) = CONVERT(date, getdate())
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetTokenCostToday] TO PUBLIC
    AS [dbo];