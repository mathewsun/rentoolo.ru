CREATE FUNCTION dbo.fnGetTablesRows ()
RETURNS table
AS
RETURN 
(
	SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
	FROM 
		  sys.objects AS sOBJ
		  INNER JOIN sys.partitions AS sPTN
				ON sOBJ.object_id = sPTN.object_id
	WHERE
		  sOBJ.type = 'U'
		  AND sOBJ.is_ms_shipped = 0x0
		  AND index_id < 2 -- 0:Heap, 1:Clustered
	GROUP BY 
		  sOBJ.schema_id
		  , sOBJ.name
	--ORDER BY [RowCount] desc
);
GO