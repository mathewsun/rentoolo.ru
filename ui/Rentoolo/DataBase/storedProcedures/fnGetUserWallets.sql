CREATE FUNCTION [dbo].[fnGetUserWallets] (@userId uniqueidentifier)
RETURNS table
AS
RETURN 
(
	SELECT 	w.[Id]
		,w.[CurrencyId]
		,w.[Value]
		,c.[Name]
		,c.[Acronim]
	FROM [Wallets] w
	LEFT JOIN [Currencies] c
	ON w.[CurrencyId] = c.[Id]
	WHERE w.[UserId] = @userId
);

GO
