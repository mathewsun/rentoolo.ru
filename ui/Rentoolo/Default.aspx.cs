using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class _Default : Page
    {
        public List<Rentoolo.Model.News> ListNews;

        public List<Adverts> ListAdverts;

        public string AdvertsCount;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //ListNews = DataHelper.GetActiveNewsLast5();

                DateTime startDate, endDate;
                DateTime? startDate2 = null, endDate2 = null;
                DateTime defaultDate = DateTime.Parse("01-01-0001 00:00:00");

                bool onlyInName = Request.QueryString["onlyInName"] == "on" ? true : false;


                decimal? startPrice = null, endPrice = null;
                decimal startPrice2, endPrice2;


                string city = Request.QueryString["city"];

                string strStartDate = Request.QueryString["startDate"];
                string strEndDate = Request.QueryString["endDate"];

                


                SellFilter filter = new SellFilter
                {
                    Search = Request.QueryString["s"]
                };

                if (DateTime.TryParse(Request.QueryString["startDate"], out startDate) || DateTime.TryParse(Request.QueryString["endDate"], out endDate))
                {
                    filter.Search = "";
                    DateTime.TryParse(Request.QueryString["endDate"], out endDate);

                    if (startDate != TestSellFilter.DefaultDate)
                    {
                        startDate2 = startDate;
                    }
                    if (endDate != TestSellFilter.DefaultDate)
                    {
                        endDate2 = endDate;
                    }
                }

                if(decimal.TryParse(Request.QueryString["startPrice"],out startPrice2)||decimal.TryParse(Request.QueryString["endPrice"],out endPrice2))
                {
                    decimal.TryParse(Request.QueryString["endPrice"], out endPrice2);
                    if (startPrice2 != null)
                    {
                        startPrice = startPrice2;
                    }

                    if (endPrice2 != null)
                    {
                        endPrice = endPrice2;
                    }

                }





                TestSellFilter testSellFilter = new TestSellFilter()
                {
                    Search = Request.QueryString["s"],
                    StartDate = startDate2,
                    EndDate = endDate2,
                    City = city,
                    StartPrice = startPrice,
                    EndPrice = endPrice,
                    OnlyInName = onlyInName
                };

                ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(testSellFilter);



                //if (DateTime.TryParse(Request.QueryString["startDate"], out startDate) || DateTime.TryParse(Request.QueryString["endDate"], out endDate))
                //{
                //    filter.Search = "";
                //    DateTime.TryParse(Request.QueryString["endDate"], out endDate);

                //    if ((startDate != defaultDate) && (endDate != defaultDate))
                //    {
                //        ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter, startDate, endDate);
                //    }
                //    else if (startDate != defaultDate)
                //    {
                //        ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter, startDate);

                //    }
                //    else if (endDate != defaultDate)
                //    {
                //        ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter, endDate, true);
                //    }

                //}
                //else
                //{
                //    ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter);
                //}


                AdvertsCount = AdvertsDataHelper.GetAdvertsActiveCount(filter).ToString("N0");





                //Random rnd = new Random();

                //RandomInt = rnd.Next(-2, 2);

                //UsercCount = DataHelper.GetSettingByName("UsersCount").Value;

                //UsersCountRegisteredToday = DataHelper.GetSettingByName("UsersCountRegisteredToday").Value;

                //UsersCountOnline = DataHelper.GetSettingByName("UsersCountOnline").Value;

                //UsersCountOnline = (Convert.ToInt32(UsersCountOnline) + RandomInt).ToString();

            }
        }

        protected void Test()
        {
            //var terterte = DataHelper.GetEnteredCO();

            //PayPayMakeTransferClassTEst tetetet = new PayPayMakeTransferClassTEst();

            //List<PayPayMakeTransferClassTEst> list = new List<PayPayMakeTransferClassTEst>();

            //CashOuts item = DataHelper.GetCashOutForPayment();

            //if (item != null)
            //{
            //    tetetet.QRecepient = item.Number;
            //    tetetet.Value = item.Value;


            //    Rentoolo.Model.Phones acc = DataHelper.GetQiwiAcoountCashOut(item.Value);

            //    tetetet.Ql = acc.Number;
            //    tetetet.Qp = acc.Pwd;

            //    list.Add(tetetet);
            //}
        }

        public void LoginStatus1_LoggedOut(Object sender, System.EventArgs e)
        {
            Session.Remove("User");

            Response.Redirect("/");
        }

        protected void ButtonSearch_Click(object sender, EventArgs e)
        {
            string search = String.Format("{0}", Request.Form["InputSearch"]);

            // creating query string(queryStr) for redirect to this page with search parameters

            string startDate = Request.Form["StartDate"];
            string endDate = Request.Form["EndDate"];

            string onlyInName = Request.Form["onlyInName"];

            string startPrice = Request.Form["startPrice"];
            string endPrice = Request.Form["endPrice"];

            string city = Request.Form["city"];

            string queryStr = "?"+ "s=" + search;

            queryStr += "&startDate=" + startDate + "&endDate=" + endDate;
            queryStr += "&onlyInName=" + onlyInName;
            queryStr += "&startPrice=" + startPrice + "&endPrice=" + endPrice;
            queryStr += "&city=" + city;


            Response.Redirect("/Default.aspx" + queryStr);

            //Response.Redirect("/Default.aspx?s=" + Uri.EscapeDataString(search) +
            //    "&startDate=" + startDate + "&endDate=" + endDate);
        }
    }
}