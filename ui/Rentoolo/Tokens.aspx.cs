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

        public double OneTokenTodayCost = 0;

        public List<fnGetUserWallets_Result> UserWalletsList;

        public fnGetUserWallets_Result UserWalletRURT = new fnGetUserWallets_Result { CurrencyId = 1, Value = 0 };

        public fnGetUserWallets_Result UserWalletRENT = new fnGetUserWallets_Result { CurrencyId = 8, Value = 0 };

        public long AvailableTokensCount = 4900000000;

        public long SellTokensCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            OneTokenTodayCost = TokensDataHelper.GetOneTokensCost();

            AvailableTokensCount = TokensDataHelper.GetAvailableTokensCount();

            SellTokensCount = 4900000000 - AvailableTokensCount;

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
                Response.Redirect("/Account/Login?ReturnUrl=Tokens");
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

            DateTime currentDate = DateTime.Now;

            int hoursCount = currentDate.Hour;

            double percentsPow = Math.Pow(1.00002897611, hoursCount);

            double currentHourValue = OneTokenTodayCost * percentsPow;

            int hoursCountPlus = hoursCount + 1;

            double percentsPowPlusHour = Math.Pow(1.00002897611, hoursCountPlus);

            double plusHourValue = OneTokenTodayCost * percentsPowPlusHour;

            double diffValuePlusHour = plusHourValue - currentHourValue;

            double secondValue = diffValuePlusHour / 3600;

            int secondsCount = currentDate.Minute * 60 + currentDate.Second;

            double diffValue = secondsCount * secondValue;

            double currentValue = currentHourValue + diffValue;

            double sum = tokensCountBuy * currentValue;

            Wallets userWallet = WalletsHelper.GetUserWallet(User.UserId, (int)CurrenciesEnum.RURT);

            if (userWallet == null || userWallet.Value < sum)
            {
                Result = "No balance";

                return;
            }

            Model.TokensBuying tokensBuying = new Model.TokensBuying
            {
                UserId = User.UserId,
                CostOneToken = currentValue,
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

            TokensDataHelper.UpdateAvailableTokensCount(AvailableTokensCount - tokensCountBuy);

            Response.Redirect("Tokens");
        }

        protected void ButtonSellTokens_Click(object sender, EventArgs e)
        {
            if (User == null)
            {
                Response.Redirect("/Account/Login?ReturnUrl=Tokens");
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

            DateTime currentDate = DateTime.Now;

            int hoursCount = currentDate.Hour;

            double percentsPow = Math.Pow(1.00002897611, hoursCount);

            double currentHourValue = OneTokenTodayCost * percentsPow;

            int hoursCountPlus = hoursCount + 1;

            double percentsPowPlusHour = Math.Pow(1.00002897611, hoursCountPlus);

            double plusHourValue = OneTokenTodayCost * percentsPowPlusHour;

            double diffValuePlusHour = plusHourValue - currentHourValue;

            double secondValue = diffValuePlusHour / 3600;

            int secondsCount = currentDate.Minute * 60 + currentDate.Second;

            double diffValue = secondsCount * secondValue;

            double currentValue = currentHourValue + diffValue;

            double sum = tokensCountSell * currentValue;

            Wallets userWalletRent = WalletsHelper.GetUserWallet(User.UserId, (int)CurrenciesEnum.RENT);

            if (userWalletRent.Value < tokensCountSell)
            {
                Result = "No tokens";

                return;
            }

            Model.TokensSelling tokensSelling = new Model.TokensSelling
            {
                UserId = User.UserId,
                CostOneToken = currentValue,
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

            TokensDataHelper.UpdateAvailableTokensCount(AvailableTokensCount + tokensCountSell);

            Response.Redirect("Tokens");

        }
    }
}