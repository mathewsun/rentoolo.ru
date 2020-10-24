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
                DateTime defaultDate = DateTime.Parse("01-01-0001 00:00:00");

                SellFilter filter = new SellFilter
                {
                    Search = Request.QueryString["s"]
                };

                if (DateTime.TryParse(Request.QueryString["startDate"], out startDate)|| DateTime.TryParse(Request.QueryString["endDate"], out endDate))
                {
                    filter.Search = "";
                    DateTime.TryParse(Request.QueryString["endDate"], out endDate);

                    if ((startDate != defaultDate) && (endDate != defaultDate))
                    {
                        ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter, startDate, endDate);
                    }
                    else if (startDate != defaultDate)
                    {
                        ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter, startDate);
                        
                    }
                    else if (endDate != defaultDate)
                    {
                        ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter, endDate, true);
                    }

                }
                else
                {
                    ListAdverts = AdvertsDataHelper.GetAdvertsForMainPage(filter);
                }


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

            string startDate = Request.Form["StartDate"];
            string endDate = Request.Form["EndDate"];

            string queryStr = "?"+ "s=" + search;

            if (startDate != null && endDate != null)
            {
                queryStr += "&startDate=" + startDate + "&endDate=" + endDate;
            }else if (startDate != null)
            {
                queryStr += "&startDate=" + startDate;
            }
            else if(endDate!=null){
                queryStr += "&endDate=" + endDate;
            }


            Response.Redirect("/Default.aspx" + queryStr);

            //Response.Redirect("/Default.aspx?s=" + Uri.EscapeDataString(search) +
            //    "&startDate=" + startDate + "&endDate=" + endDate);
        }
    }
}