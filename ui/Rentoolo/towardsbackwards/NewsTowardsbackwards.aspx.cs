using System;
using System.Collections.Generic;
 using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.towardsbackwards
{
    public partial class NewsTowardsbackwards : System.Web.UI.Page
    {
        public List<Rentoolo.Model.News_towardsbackwards> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperTowardsbackwards.GetActiveNews();
        }
    }
}