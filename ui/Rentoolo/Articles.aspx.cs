using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class Articles : System.Web.UI.Page
    {
        public List<Model.Articles> ListArticles;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListArticles = DataHelper.GetArticles();
        }
    }
}