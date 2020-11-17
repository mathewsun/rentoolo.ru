using Rentoolo.HelperModels;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.CraftsMan
{
    public partial class CraftsManPage : System.Web.UI.Page
    {


        public List<Rentoolo.Model.CraftsMan> ListCraftsMan;

        public string CraftsManCount;

        public string[] AllCities = RusCities.AllRusCities;

        public SellFilter PreviousFilter = new SellFilter();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //ListNews = DataHelper.GetActiveNewsLast5();

                DateTime startDate, endDate;
                DateTime? startDate2 = null, endDate2 = null;

                bool onlyInName = Request.QueryString["onlyInName"] == "on" ? true : false;

                decimal? startPrice = null, endPrice = null;
                decimal startPrice2, endPrice2;

                string city = Request.QueryString["city"];

                string sortBy = Request.QueryString["sort"];

                SellFilter filter = new SellFilter
                {
                    Search = Request.QueryString["s"]
                };

                if (DateTime.TryParse(Request.QueryString["startDate"], out startDate) || DateTime.TryParse(Request.QueryString["endDate"], out endDate))
                {
                    filter.Search = "";
                    DateTime.TryParse(Request.QueryString["endDate"], out endDate);

                    if (startDate != SellFilter.DefaultDate)
                    {
                        startDate2 = startDate;
                    }
                    if (endDate != SellFilter.DefaultDate)
                    {
                        endDate2 = endDate;
                    }
                }

                if (decimal.TryParse(Request.QueryString["startPrice"], out startPrice2) || decimal.TryParse(Request.QueryString["endPrice"], out endPrice2))
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

                // test
                string userIP = Request.RequestContext.HttpContext.Request.UserHostAddress;

                SellFilter sellFilter = new SellFilter()
                {
                    Search = Request.QueryString["s"],
                    StartDate = startDate2,
                    EndDate = endDate2,
                    City = city,
                    StartPrice = startPrice,
                    EndPrice = endPrice,
                    OnlyInName = onlyInName,
                    SortBy = sortBy
                };

                ListCraftsMan = CraftsManDataHelper.GetCraftsManForMainPage(sellFilter);

                CraftsManCount = CraftsManDataHelper.GetCraftsManActiveCount(filter).ToString("N0");


                PreviousFilter = sellFilter;

            }

         
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

            string sortBy = Request.Form["sortBy"];

            string queryStr = "?" + "s=" + search;

            queryStr += "&startDate=" + startDate + "&endDate=" + endDate;
            queryStr += "&onlyInName=" + onlyInName;
            queryStr += "&startPrice=" + startPrice + "&endPrice=" + endPrice;
            queryStr += "&city=" + city;
            queryStr += "&sort=" + sortBy;

            Response.Redirect("/Default.aspx" + queryStr);
        }
        public void LoginStatus1_LoggedOut(Object sender, System.EventArgs e)
        {
            Session.Remove("User");

            Response.Redirect("/");
        }
    }
}