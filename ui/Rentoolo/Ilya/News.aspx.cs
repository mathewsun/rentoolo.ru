using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Ilya
{
    public partial class News : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewsIlya> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperIlya.GetActiveNews();
        }
    }
}