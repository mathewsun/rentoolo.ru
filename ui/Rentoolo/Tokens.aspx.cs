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

        public List<fnGetUserWallets_Result> UserWalletsList;

        public fnGetUserWallets_Result UserWalletRURT = new fnGetUserWallets_Result { CurrencyId = 1, Value = 0 };

        public fnGetUserWallets_Result UserWalletRENT = new fnGetUserWallets_Result { CurrencyId = 8, Value = 0 };

        protected void Page_Load(object sender, EventArgs e)
        {
            OneTokenTodayCost = TokensDataHelper.GetOneTokensCost();

            if (User != null)
            {
                UserWalletsList = WalletsHelper.GetUserWallets(User.UserId);

                UserWalletRURT = UserWalletsList.Where(x => x.CurrencyId == (int)CurrenciesEnum.RURT).FirstOrDefault();

                if (UserWalletRURT == null) UserWalletRURT = new fnGetUserWallets_Result { CurrencyId = (int)CurrenciesEnum.RURT, Value = 0 };

                UserWalletRENT = UserWalletsList.Where(x => x.CurrencyId == (int)CurrenciesEnum.RENT).FirstOrDefault();

                if (UserWalletRENT == null) UserWalletRENT = new fnGetUserWallets_Result { CurrencyId = (int)CurrenciesEnum.RENT, Value = 0 };
            }
        }

        protected void ButtonBuyTokens_Click(object sender, EventArgs e)
        {
            if (User == null)
            {
                Response.Redirect("/Account/Login.aspx?ReturnUrl=Tokens.aspx");
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

                return;
            }

            if (tokensCountBuy == 0)
            {
                Result = "Zero count";

                return;
            }

            if (tokensCountBuy < 0)
            {
                Result = "Below zero count value";

                return;
            }

            float sum = tokensCountBuy * OneTokenTodayCost;

            Wallets userWallet = WalletsHelper.GetUserWallet(User.UserId, (int)CurrenciesEnum.RURT);

            if (userWallet == null || userWallet.Value < sum)
            {
                Result = "No balance";

                return;
            }

            Model.TokensBuying tokensBuying = new Model.TokensBuying
            {
                UserId = User.UserId,
                CostOneToken = OneTokenTodayCost,
                Count = tokensCountBuy,
                FullCost = sum,
                WhenDate = DateTime.Now
            };

            TokensDataHelper.AddTokensBuying(tokensBuying);

            WalletsHelper.UpdateUserWallet(User.UserId, (int)CurrenciesEnum.RURT, -sum);

            WalletsHelper.UpdateUserWallet(User.UserId, (int)CurrenciesEnum.RENT, tokensCountBuy);

            #region Логирование операции

            {
                Rentoolo.Model.Operations operation = new Rentoolo.Model.Operations
                {
                    UserId = User.UserId,
                    Value = tokensCountBuy,
                    Type = (int)OperationTypesEnum.Registration,
                    Comment = string.Format("Покупка {0} токенов на сумму {1}.", tokensCountBuy, sum),
                    WhenDate = DateTime.Now
                };

                DataHelper.AddOperation(operation);
            }

            #endregion

            Response.Redirect("Tokens.aspx");
        }

        protected void ButtonSellTokens_Click(object sender, EventArgs e)
        {
            if (User == null)
            {
                Response.Redirect("/Account/Login.aspx?ReturnUrl=Tokens.aspx");
            }

            string tokensCountSellString = String.Format("{0}", Request.Form["ctl00$MainContent$tokensCountSell"]);

            long tokensCountSell = 0;

            try
            {
                tokensCountSell = Int64.Parse(tokensCountSellString);
            }
            catch
            {
                Result = "Wrong count";

                return;
            }

            if (tokensCountSell == 0)
            {
                Result = "Zero tokens";

                return;
            }

            if (tokensCountSell < 0)
            {
                Result = "Below zero tokens value";

                return;
            }

            float sum = tokensCountSell * OneTokenTodayCost;

            Wallets userWalletRent = WalletsHelper.GetUserWallet(User.UserId, (int)CurrenciesEnum.RENT);

            if (userWalletRent.Value < tokensCountSell)
            {
                Result = "No tokens";

                return;
            }

            Model.TokensSelling tokensSelling = new Model.TokensSelling
            {
                UserId = User.UserId,
                CostOneToken = OneTokenTodayCost,
                Count = tokensCountSell,
                FullCost = sum,
                WhenDate = DateTime.Now
            };

            TokensDataHelper.AddTokensSelling(tokensSelling);

            WalletsHelper.UpdateUserWallet(User.UserId, (int)CurrenciesEnum.RURT, sum);

            WalletsHelper.UpdateUserWallet(User.UserId, (int)CurrenciesEnum.RENT, -tokensCountSell);

            #region Логирование операции

            {
                Rentoolo.Model.Operations operation = new Rentoolo.Model.Operations
                {
                    UserId = User.UserId,
                    Value = tokensCountSell,
                    Type = (int)OperationTypesEnum.Registration,
                    Comment = string.Format("Продажа {0} токенов на сумму {1}.", tokensCountSell, sum),
                    WhenDate = DateTime.Now
                };

                DataHelper.AddOperation(operation);
            }

            #endregion

            Response.Redirect("Tokens.aspx");

        }
    }
}