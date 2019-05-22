using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class LoginStatisticsToday : System.Web.UI.Page
    {
        public List<Model.LoginStatistics> ListSite;

        public List<Model.LoginStatistics> ListDesctop;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListDesctop = DataHelper.GetLoginStatisticByClientToday(1);
            }
        }
    }
}