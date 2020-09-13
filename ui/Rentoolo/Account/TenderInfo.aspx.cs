using Rentoolo.DatabaseHelpers;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class TenderInfo : System.Web.UI.Page
    {
        public Tenders tender = new Tenders(); 


        protected void Page_Load(object sender, EventArgs e)
        {
            tender = TendersHelper.GetTenderById(Convert.ToInt32(Request.QueryString["id"]));
        }
    }
}