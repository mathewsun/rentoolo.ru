USE [Rentoolo]
GO
/****** Object:  StoredProcedure [dbo].[spGetExchangeItemRequests]    Script Date: 23.11.2020 23:03:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[spGetExchangeItemRequests]
(@exchangeItemId bigint)
AS
BEGIN


SELECT exr.id
	, adv.Name
	, adv.Color
	, adv.Id as advertId


	FROM dbo.ExchangeItemRequests as exr 
	LEFT JOIN dbo.Adverts as adv ON ( exr.ExchangeItemId = adv.Id)
	WHERE exr.WantedExchangeItemId = @exchangeItemId
	

END

GRANT EXECUTE
    ON OBJECT::[dbo].[spGetExchangeItemRequests] TO PUBLIC
    AS [dbo];