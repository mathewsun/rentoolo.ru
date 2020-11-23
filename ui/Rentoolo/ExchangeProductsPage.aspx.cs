using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class ExchangeProductsPage : System.Web.UI.Page
    {
        public List<spGetExchangeProducts_Result> ExchangeItems;
        protected void Page_Load(object sender, EventArgs e)
        {
            string search = Request.QueryString["search"] == null ? "" : Request.QueryString["search"];

            search = "%" + search + "%";

            ExchangeItems = DataHelper.GetExchangeItems(search);

            var a = 5;
        }

        protected void ButtonSearch_Click(object sender, EventArgs e)
        {
            string search = Request.Form["search"]==null?"": Request.Form["search"];

            Response.Redirect("ExchangeProductsPage.aspx?search=" + search);

        }
    }
}