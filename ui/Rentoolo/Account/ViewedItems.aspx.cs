using Rentoolo.Model;
using Rentoolo.Model.HelperStructs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class ViewedItems : BasicPage
    {
        //public List<Model.UserViews> Views = new List<Model.UserViews>();
        public List<Model.SelIItem> SellItemViews = new List<SelIItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            string category = Request.QueryString["category"];
            string startDateS = Request.QueryString["startDate"];
            string endDateS = Request.QueryString["endDate"];

            bool isRedirect = Request.QueryString["redirect"] == "true";
            string objectId = Request.QueryString["objectId"];

            DateTime? startDate, endDate;
            startDate = startDateS == null || startDateS == "" ? null : (DateTime?)DateTime.Parse(startDateS);
            endDate = endDateS == null || endDateS == "" ? null : (DateTime?)DateTime.Parse(endDateS);

            int? categoryType = null;
            if (category != null)
            {
                categoryType = StructsHelper.ViewedType[category];
            }

            if (isRedirect)
            {
                string pageURl = StructsHelper.TypePage[(int)categoryType] + "?id=" + category;
                Response.Redirect(pageURl);
            }




            SellItemViews = DataHelper.GetSellItems(categoryType, User.UserId, startDate, endDate);

        }


        string tryAddToQuery(string name, string val, bool isFirst = false)
        {
            string and = "&";
            if (isFirst)
            {
                and = "";
            }

            string output = "";
            if (val != null)
            {
                output += and + name + "=" + val;
            }

            return output;
        }

        protected void ButtonSearch_Click(object sender, EventArgs e)
        {
            string category = Request.Form["category"];
            string startDate = Request.Form["startDate"];
            string endDate = Request.Form["endDate"];


            string query = "?" + tryAddToQuery("category", category, true);
            query += tryAddToQuery("startDate", startDate);
            query += tryAddToQuery("endDate", endDate);

            Response.Redirect("ViewedItems.aspx" + query);

        }
    }
}