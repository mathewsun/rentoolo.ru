using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class News : System.Web.UI.Page
    {
        public List<New> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelper.GetActiveNews();
        }
    }
}