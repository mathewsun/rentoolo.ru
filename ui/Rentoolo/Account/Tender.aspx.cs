using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.DatabaseHelpers;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Tender : System.Web.UI.Page
    {
        public List<Tenders> tenders;

        protected void Page_Load(object sender, EventArgs e)
        {
            var name = Request.QueryString["name"];
            tenders = name == null ? TendersHelper.GetAllTenders() : TendersHelper.GetTenders(name);
        }
    }
}