ALTER PROCEDURE  [dbo].[spGetLast200TokensOperations]
@UserId uniqueidentifier
AS
BEGIN
	SELECT TOP 200 a.* FROM
    (
    SELECT TOP (1000) 
    [Count]
          ,[UserId]
          ,[CostOneToken]
          ,[FullCost]
          ,[WhenDate]
      FROM [TokensBuying]
      Union
      SELECT TOP (1000) 
      [Count]
          ,[UserId]
          ,[CostOneToken]
          ,[FullCost]
          ,[WhenDate]
      FROM [TokensSelling]
      Order by [WhenDate]
      ) AS a
    ORDER BY [WhenDate] desc
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetLast200TokensOperations] TO PUBLIC
    AS [dbo];
	