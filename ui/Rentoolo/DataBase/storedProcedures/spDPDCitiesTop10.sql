CREATE PROCEDURE [spDPDCitiesTop10]
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
FROM [Rentoolo222].[dbo].[DpdCities]
Where 
[cityName] like '%'+@text+'%'
Order by Population desc
END
GO
