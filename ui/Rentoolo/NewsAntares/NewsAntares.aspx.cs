using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.NewsAntares
{
    public partial class NewsAntares : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewsAntares> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperAntares.GetActiveNews();
        }
    }
}