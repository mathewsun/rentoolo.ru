using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account.TenderViews
{
    public partial class UsersTenderRequests : System.Web.UI.Page
    {
        // TODO: null ref exception
        public List<TenderRequest> TenderRequests;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                int id = Convert.ToInt32(Request.QueryString["uid"]);
                TenderRequests = TendersHelper.GetUsersTRequests(id);
                
            }
        }
    }
}