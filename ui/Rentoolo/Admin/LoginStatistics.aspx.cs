using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class LoginStatistics : System.Web.UI.Page
    {
        public List<Model.LoginStatistics> ListSite;

        public List<Model.LoginStatistics> ListDesctop;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListSite = DataHelper.GetLoginStatisticByClient(0);

                ListDesctop = DataHelper.GetLoginStatisticByClient(1);
            }
        }
    }
}