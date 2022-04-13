using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.LateBloomer
{
    public partial class NewaLateBloomer : System.Web.UI.Page
    {
        public List<Model.NewsLateBloomer> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperLateBloomer.GetActiveNews();
        }
    }
}