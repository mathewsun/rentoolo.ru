using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Web.UI;

namespace Rentoolo.Azizjan
{
    public partial class NewsAzizjan : Page
    {
        public List<Model.NewsAzizjan> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperAzizjan.GetActiveNews();
        }
    }
}