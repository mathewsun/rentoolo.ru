using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Aezakmi128
{
    public partial class Aezakmi : System.Web.UI.Page
    {
        public List<Rentoolo.Model.NewAezakmi> ListNews;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListNews = DataHelperAezakmi.GetActiveNewsLast5();
        }

    }
}