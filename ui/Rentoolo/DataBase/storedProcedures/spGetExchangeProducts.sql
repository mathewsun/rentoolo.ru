USE [Rentoolo]
GO
/****** Object:  StoredProcedure [dbo].[spGetExchangeProducts]    Script Date: 23.11.2020 22:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[spGetExchangeProducts]
(@query nvarchar(30))
AS
BEGIN

	SELECT 
		expr.[Id]
      ,expr.[AdvertId]
      ,expr.[Comment]
      ,expr.[WantedObject]
      ,expr.[Header]
	  ,adv.[Category]
      ,adv.[Name]
      ,adv.[Created]
      ,adv.[Price]
      ,adv.[Address]
      ,adv.[IsApproved]
      ,adv.[Subcategory]
      ,adv.[Color]
      ,adv.[Vin]
      ,adv.[Brand]

	  
	FROM dbo.ExchangeProducts AS expr
	LEFT JOIN dbo.Adverts AS adv
	ON expr.AdvertId = adv.Id 
	WHERE (adv.Name LIKE @query) OR (adv.Description LIKE @query) 
	OR (expr.Header LIKE @query) OR (expr.Comment LIKE @query) OR (expr.WantedObject LIKE @query)

END

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetExchangeProducts] TO PUBLIC
    AS [dbo];