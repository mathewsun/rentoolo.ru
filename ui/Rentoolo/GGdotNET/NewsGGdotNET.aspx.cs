using Rentoolo.Model;
using System;
using System.Collections.Generic;

namespace Rentoolo.GGdotNET
{
    public partial class NewsGGdotNET : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewsGGdotNET> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperGGdotNET.GetActiveNews();
        }
    }
}