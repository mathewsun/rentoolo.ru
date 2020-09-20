using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class Tenders : System.Web.UI.Page
    {
        public List<Model.Tenders> TendersList;

        protected void Page_Load(object sender, EventArgs e)
        {
            var name = Request.Form["name"];
            TendersList = name == null ? TendersHelper.GetAllTenders() : TendersHelper.GetTenders(name);
        }
    }
}