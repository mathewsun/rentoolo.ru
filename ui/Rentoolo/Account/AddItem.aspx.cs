using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class AddItem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonAddItem_Click(object sender, EventArgs e)
        {
            string category = String.Format("{0}", Request.Form["ctl00$MainContent$category_hidden"]);
            string name = String.Format("{0}", Request.Form["ctl00$MainContent$input_name"]);
            string description = String.Format("{0}", Request.Form["ctl00$MainContent$input_text"]);
            string price = String.Format("{0}", Request.Form["ctl00$MainContent$price_value"]);
            string video = String.Format("{0}", Request.Form["ctl00$MainContent$input_video"]);
            string place = String.Format("{0}", Request.Form["ctl00$MainContent$additem_place"]);
            string phone = String.Format("{0}", Request.Form["ctl00$MainContent$phonenum"]);
            string messageType = String.Format("{0}", Request.Form["ctl00$MainContent$contact"]);

        }
    }
}