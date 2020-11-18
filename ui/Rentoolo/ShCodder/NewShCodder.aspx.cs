using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Web.UI;

namespace Rentoolo.ShCodder
{
    public partial class NewShCodder : Page
    {
        public List<NewsShCodder> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperShCodder.GetActiveNews();
        }
    }
}