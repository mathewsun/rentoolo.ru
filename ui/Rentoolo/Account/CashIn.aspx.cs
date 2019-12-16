using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class CashIn : BasicPage
    {
        public string QiwiAccount;

        public string QiwiAccountCheck;

        protected void Page_Load(object sender, EventArgs e)
        {
            QiwiAccount = QiwiHelper.GetCurrentQiwiAccount().Login;

            QiwiAccountCheck = QiwiAccount;
        }
    }
}