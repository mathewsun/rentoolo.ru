using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Vlad
{
    public partial class NewsVlad : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewsVlad> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperVlad.GetActiveNews();
        }
    }
}