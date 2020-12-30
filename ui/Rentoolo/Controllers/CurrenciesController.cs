using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class CurrenciesController : ApiController
    {
        public class Currencies
        {
            public string CurrencyOfMetal = "USD";
            public string Unit = "Ounce";
            public string CurrencyOfValute = "RUB";
            public Dictionary<string, double> Rates { get; set; } = new Dictionary<string, double>();
        } 
        public CurrenciesController()
        {
        }


        public IHttpActionResult GetCurrencies(string currencyOfMetal = "USD", string currencyOfValute = "USD")
        {
            Currencies currencies = new Currencies();

            currencies.CurrencyOfMetal = currencyOfMetal;
            currencies.CurrencyOfValute = currencyOfValute;

            Dictionary<string, double> valuteCurrencies = GetValuteCurrencies();
            Dictionary<string, double> metalCurrencies = GetMetalCurrencies();


            if ((!valuteCurrencies.ContainsKey(currencyOfValute) && currencyOfValute != "USD") ||
                (!valuteCurrencies.ContainsKey(currencyOfMetal) && currencyOfMetal != "USD"))
            {
                return BadRequest("You entered a currency of an unknown type");
            }

            double selectedValuteCurrency = 0;
            double selectedMetalCurrency = 0;

            foreach (KeyValuePair<string, double> valuteCurrency in valuteCurrencies)
            {
                if (selectedMetalCurrency != 0 && selectedValuteCurrency != 0) break;
                else if (currencyOfMetal == "USD" && selectedValuteCurrency != 0) break;
                else if (currencyOfValute == "USD" && selectedMetalCurrency != 0) break;
                else if (currencyOfValute == "USD" && currencyOfMetal == "USD") break;

                if (valuteCurrency.Key == currencyOfMetal)
                {
                    selectedMetalCurrency = valuteCurrency.Value;
                }
                if(valuteCurrency.Key == currencyOfValute)
                {
                    selectedValuteCurrency = valuteCurrency.Value;
                }
            }

            if (currencyOfMetal != "USD")
            {
                foreach (KeyValuePair<string, double> metalCurrency in metalCurrencies)
                {
                    currencies.Rates.Add(metalCurrency.Key, Math.Round(metalCurrency.Value * selectedMetalCurrency, 5));
                }
            }
            else
            {
                currencies.Rates = metalCurrencies;
            }

            if(currencyOfValute != "USD")
            {
                foreach(KeyValuePair<string, double> valuteCurrency in valuteCurrencies)
                {
                    currencies.Rates.Add(valuteCurrency.Key, Math.Round(selectedValuteCurrency / valuteCurrency.Value, 5));
                }
            }
            else
            {
                foreach (KeyValuePair<string, double> valuteCurrency in valuteCurrencies)
                {
                    currencies.Rates.Add(valuteCurrency.Key, valuteCurrency.Value);
                }
            }
            
            return Json(currencies);
        }
        private Dictionary<string, double> GetMetalCurrencies()
        {
            Dictionary<string, double> currencies = new Dictionary<string, double>();
            using (WebClient client = new WebClient()) // WebClient class inherits IDisposable
            {
                client.Headers[HttpRequestHeader.Upgrade] = "1";
                client.Headers[HttpRequestHeader.UserAgent] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36";
                client.Headers[HttpRequestHeader.Accept] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,en;q=0.7";
                client.Headers[HttpRequestHeader.AcceptEncoding] = "gzip, deflate, br";
                var data = client.DownloadData("https://www.moex.com/ru/derivatives/commodity/gold/");
                string htmlCode = string.Empty;
                using (var msi = new MemoryStream(data))
                using (var mso = new MemoryStream())
                {
                    msi.Seek(0, SeekOrigin.Begin);
                    using (var gs = new GZipStream(msi, CompressionMode.Decompress))
                    {
                        byte[] bytes = new byte[4096];
                        int cnt;
                        while ((cnt = gs.Read(bytes, 0, bytes.Length)) != 0)
                        {
                            mso.Write(bytes, 0, cnt);
                        }
                    }
                    htmlCode = Encoding.UTF8.GetString(mso.ToArray());
                }
                var matches = Regex.Matches(htmlCode, "(?<=>)([1-9]+.[\\d,]+)+|([\\d,])(?=<)");
                int index = 0;
                foreach (Match item in matches)
                {
                    if (index == 8)
                    {
                        currencies.Add("XAU", double.Parse(item.Value.Replace(" ", "")));
                    }
                    else if (index == 16)
                    {
                        currencies.Add("PAL", double.Parse(item.Value.Replace(" ", "")));
                    }
                    else if (index == 23)
                    {
                        currencies.Add("PL", double.Parse(item.Value.Replace(" ", "")));
                    }
                    else if (index == 30)
                    {
                        currencies.Add("XAG", double.Parse(item.Value.Replace(" ", "")));
                    }
                    index++;
                }
            }
            return currencies;
        }


        private Dictionary<string, double> GetValuteCurrencies()
        {
            Dictionary<string, double> currencies = new Dictionary<string, double>();
            using (WebClient client = new WebClient())
            {
                client.Encoding = Encoding.UTF8;
                var htmlCode = client.DownloadString("https://ru.exchange-rates.org/currentRates/E/USD");
                var ratesMatches = Regex.Matches(htmlCode, "(?<a>)([0-9]+,[0-9]+)+(?=<)");
                var codeOfRatesMatches = Regex.Matches(htmlCode, "(?<a>)(Обмен.*?)+(?=</a>)");
                for (int i = 0; i < ratesMatches.Count; i++)
                {
                    currencies.Add(codeOfRatesMatches[i].Value.Split()[3], double.Parse(ratesMatches[i].Value));
                }
            }
            return currencies;
        }
    }
}