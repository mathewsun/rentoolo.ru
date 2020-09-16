using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account.TenderViews
{
    public partial class WinedTenderRequest : System.Web.UI.Page
    {
        public TenderRequest TReq;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // tender id
                int id = Convert.ToInt32(Request.QueryString["id"]);
                TReq = TendersHelper.GetWinedTRequest(id);
                
            }
        }
    }
}