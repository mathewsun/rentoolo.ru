using HtmlAgilityPack;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class CurrenciesController : ApiController
    {
        public class Currency
        {
            public CurrencyTypeEnum Type { get; set; }
            public float Price { get; set; }
        }

        public enum CurrencyTypeEnum
        {
            Gold = 1,
            Silver = 2,
            Platinum = 3,
            Palladium = 4,
            Euro = 5,
            Dollar = 6
        }

        private HtmlWeb _hb;
        public CurrenciesController()
        {
            _hb = new HtmlWeb();
        }

        public IHttpActionResult GetCurrencies()
        {
            List<Currency> currencies = GetMetalCurrencies(_hb);
            currencies.AddRange(GetValuteCurrencies(_hb));
            return Json(currencies);
        }
        private List<Currency> GetMetalCurrencies(HtmlWeb hb)
        {
            List<Currency> currencies = new List<Currency>();

            int index = 0;
            HtmlDocument doc = hb.Load("https://www.moex.com/ru/derivatives/commodity/gold/");
            foreach (var node in doc.DocumentNode.SelectNodes("//table[contains(@class, 'table1')]").FirstOrDefault().ChildNodes)
            {
                index++;

                if (index == 3)
                {
                    currencies.Add(new Currency()
                    {
                        Type = CurrencyTypeEnum.Gold,
                        Price = float.Parse(node.ChildNodes[1].InnerText)
                    });
                }
                else if (index == 5)
                {
                    currencies.Add(new Currency()
                    {
                        Type = CurrencyTypeEnum.Palladium,
                        Price = float.Parse(node.ChildNodes[1].InnerText)
                    });
                }
                else if (index == 7)
                {
                    currencies.Add(new Currency()
                    {
                        Type = CurrencyTypeEnum.Platinum,
                        Price = float.Parse(node.ChildNodes[1].InnerText)
                    });
                }
                else if (index == 9)
                {
                    currencies.Add(new Currency()
                    {
                        Type = CurrencyTypeEnum.Silver,
                        Price = float.Parse(node.ChildNodes[1].InnerText)
                    });
                }
            }
            return currencies;
        }

        private List<Currency> GetValuteCurrencies(HtmlWeb hb)
        {
            List<Currency> currencies = new List<Currency>();
            int index = 0;
            HtmlDocument doc = hb.Load("https://www.banki.ru/products/currency/cb/");
            var nodes = doc.DocumentNode.SelectNodes("//table[contains(@class, 'standard-table standard-table--row-highlight')]").FirstOrDefault().ChildNodes[3].ChildNodes;
            foreach (var node in doc.DocumentNode.SelectNodes("//table[contains(@class, 'standard-table standard-table--row-highlight')]").FirstOrDefault().ChildNodes[3].ChildNodes)
            {
                if (index == 1)
                {
                    currencies.Add(new Currency()
                    {
                        Type = CurrencyTypeEnum.Dollar,
                        Price = float.Parse(node.ChildNodes[7].InnerText)
                    });
                }
                if (index == 3)
                {
                    currencies.Add(new Currency()
                    {
                        Type = CurrencyTypeEnum.Euro,
                        Price = float.Parse(node.ChildNodes[7].InnerText)
                    });
                    break;
                }
                index++;
            }

            return currencies;
        }
    }
}