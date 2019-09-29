using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class Tokens : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonBuyTokens_Click(object sender, EventArgs e)
        {
            string tokensCountBuyString = String.Format("{0}", Request.Form["ctl00$MainContent$tokensCountBuy"]);

            long tokensCountBuy = 0;

            try
            {
                tokensCountBuy = Int64.Parse(tokensCountBuyString);
            }
            catch { }


        }
    }
}