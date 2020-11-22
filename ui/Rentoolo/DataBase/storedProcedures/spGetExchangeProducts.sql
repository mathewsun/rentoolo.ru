USE [Rentoolo]
GO
/****** Object:  StoredProcedure [dbo].[spGetExchangeProducts]    Script Date: 22.11.2020 22:46:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[spGetExchangeProducts]
(@query nvarchar)
AS
BEGIN

	SELECT 
		expr.[Id]
      ,[AdvertId]
      ,[Comment]
      ,[WantedObject]
      ,[Header]
	  ,[Category]
      ,[Name]
      ,[Created]
      ,[Price]
      ,[Address]
      ,[IsApproved]
      ,[Subcategory]
      ,[Color]
      ,[Vin]
      ,[Brand]


	FROM dbo.ExchangeProducts as expr
	LEFT JOIN dbo.Adverts as adv
	ON expr.AdvertId = adv.Id 
	WHERE (adv.Name LIKE @query) OR (adv.Description LIKE @query) 
	OR (expr.Header LIKE @query) OR (expr.Comment LIKE @query) OR (expr.WantedObject LIKE @query)

END

