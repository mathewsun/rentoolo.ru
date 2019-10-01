using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class Tokens : BasicPage
    {
        public string Result = string.Empty;

        public float OneTokenTodayCost = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            OneTokenTodayCost = TokensDataHelper.GetOneTokensCost();
        }

        protected void ButtonBuyTokens_Click(object sender, EventArgs e)
        {
            if (User == null)
            {
                Response.Redirect("/Account/Login.aspx");
            }

            string tokensCountBuyString = String.Format("{0}", Request.Form["ctl00$MainContent$tokensCountBuy"]);

            long tokensCountBuy = 0;

            try
            {
                tokensCountBuy = Int64.Parse(tokensCountBuyString);
            }
            catch
            {
                Result = "Wrong count";
            }

            float sum = tokensCountBuy * OneTokenTodayCost;

            Wallets userWallet = WalletsHelper.GetUserWallet(User.UserId, (int)CurrenciesEnum.RURT);

            if (userWallet.Value < sum)
            {
                Result = "No balance";
            }



        }
    }
}