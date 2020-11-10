using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Education
{
    public partial class NewsEducation : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewsEducation> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperEducation.GetActiveNews();
        }
    }
}