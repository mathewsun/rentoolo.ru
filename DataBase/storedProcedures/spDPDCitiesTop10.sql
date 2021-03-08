ALTER PROCEDURE [spDPDCitiesTop10]
@text nvarchar(50)
AS
BEGIN
SELECT TOP (10) [cityId]
,[cityIdSpecified]
,[countryCode]
,[countryName]
,[regionCode]
,[regionCodeSpecified]
,[regionName]
,[cityCode]
,[cityName]
,[abbreviation]
,[indexMin]
,[indexMax]
,[Population]
,[Settled]
,[lat]
,[lng]
FROM [DpdCities]
Where 
[cityName] like '%'+@text+'%'
Order by Population desc
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].[spDPDCitiesTop10] TO PUBLIC
    AS [dbo];
