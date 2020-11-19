using Newtonsoft.Json;
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

        protected void ButtonOrder_Click(object sender, EventArgs e)
        {
           
            string nameTask = String.Format("{0}", Request.Form["MainContent$input_nameTask"]);
            string description = String.Format("{0}", Request.Form["MainContent$input_description"]);
            string price = String.Format("{0}", Request.Form["MainContent$price_value"]);
            //string video = String.Format("{0}", Request.Form["ctl00$MainContent$input_video"]);
            //string place = String.Format("{0}", Request.Form["ctl00$MainContent$additem_place"]);
            string phone = String.Format("{0}", Request.Form["MainContent$phone"]);
          
            
            
            //TODO добавить в табл
            string firstName = String.Format("{0}", Request.Form["MainContent$input_firstName"]);
            string lastName = String.Format("{0}", Request.Form["MainContent$input_lastName"]);
            string address = String.Format("{0}", Request.Form["MainContent$address"]);
            string email = String.Format("{0}", Request.Form["MainContent$email"]);
            string country = String.Format("{0}", Request.Form["MainContent$country"]);
            string region = String.Format("{0}", Request.Form["MainContent$region"]);

            //var objPhotos = Request.Form[""];



            Rentoolo.Model.CraftsManOrder order = new Model.CraftsManOrder();

            //if (objPhotos != null)
            //{
            //    String[] listPhotos = objPhotos.Split(',');

            //    var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

            //    order.ImgUrls = jsonPhotos;
            //}
            //else
            //{
            //    order.ImgUrls = "[\"/img/a/noPhoto.png\"]";
            //}

            //try
            //{
            //    order.Category = Int32.Parse(category);
            //}
            //catch { } 
            try
            {
                order.Price = double.Parse(price);
            }
            catch { }

            //order.video = video;

            //order.Address = place;

            //order.YouTubeUrl = video;

            //order.CreatedUserId = User.UserId;

            order.Created = DateTime.Now;
            order.Address = address;
            order.NameTask = nameTask;
            order.Description = description;
            order.Phone = phone;
           


            CraftsManDataHelper.AddCraftsManOrdrer(order);

            //Response.Redirect("MyAdverts.aspx");
        }
    }
}