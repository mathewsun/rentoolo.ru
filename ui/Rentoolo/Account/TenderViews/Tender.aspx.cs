using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Tender : System.Web.UI.Page
    {
        public List<Model.Tenders> tenders;

        protected void Page_Load(object sender, EventArgs e)
        {
            var name = Request.Form["name"];
            tenders = name == null ? TendersHelper.GetAllTenders() : TendersHelper.GetTenders(name);
        }
    }
}