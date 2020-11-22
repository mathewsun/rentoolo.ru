using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Eoll73
{
    public partial class NewsEoll73 : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewsEoll73> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperEoll73.GetActiveNews();
        }
    }
}