using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class CashOut : BasicPage
    {
        public List<Model.CashOuts> list;

        public int ResultOrder = 0;

        public double Balance;

        public List<fnGetUserWallets_Result> UserWalletsList;

        public fnGetUserWallets_Result UserWalletRURT;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillList();
            }
        }

        public void FillList()
        {
            UserWalletsList = WalletsHelper.GetUserWallets(User.UserId);

            UserWalletRURT = UserWalletsList.Where(x => x.CurrencyId == 1).FirstOrDefault();

            if (UserWalletRURT != null)
            {
                Balance = UserWalletRURT.Value;
            }
            else
            {
                Balance = 0;
            }

            list = DataHelper.GetUser50CashOuts(User.UserId);

            try
            {
                TextBoxNumber.Text = list.Where(x => x.Type == 1).OrderBy(x => x.WhenDate).Last().Number;
            }
            catch { }
        }

        protected void ButtonCashOut_Click(object sender, EventArgs e)
        {
            double value;

            double valueWithPercents;

            if (!double.TryParse(TextBoxCashOut.Text, out value))
            {
                ResultOrder = 3;

                FillList();

                return;
            }

            valueWithPercents = value;

            int type = Convert.ToInt32(RadioButtonListCashOutType.SelectedItem.Value);

            //if (type == 1 && !TextBoxNumber.Text.StartsWith("+79") && !TextBoxNumber.Text.StartsWith("+38"))
            //{
            //    ResultOrder = 3;

            //    FillList();

            //    return;
            //}

            if (type == 4)
            {
                valueWithPercents = valueWithPercents + 50 + (valueWithPercents / 100 * 2);
            }

            UserWalletsList = WalletsHelper.GetUserWallets(User.UserId);

            UserWalletRURT = UserWalletsList.Where(x => x.CurrencyId == 1).FirstOrDefault();

            double balance = UserWalletRURT.Value;

            if (balance < valueWithPercents || value <= 0)
            {
                ResultOrder = 2;

                FillList();

                return;
            }

            Model.CashOuts cashOut = new Model.CashOuts
            {
                Value = value,
                Sposob = TextBoxNumber.Text,
                Number = TextBoxNumber.Text,
                State = (int)CashOutStatesEnum.Entered,
                UserId = User.UserId,
                WhenDate = DateTime.Now,
                Type = type
            };

            cashOut.Id = DataHelper.AddCashOut(cashOut);

            #region Списание со счета

            DataHelper.UpdateUserBalance(User.UserId, CurrenciesEnum.RURT, -valueWithPercents, UpdateBalanceType.CashOut);

            #endregion

            #region Логирование операции

            {
                Model.Operations operation = new Model.Operations
                {
                    UserId = User.UserId,
                    Value = -valueWithPercents,
                    Type = (int)OperationTypesEnum.PaymentOut,
                    Comment = string.Format("Запрос вывода на сумму {0} р. Способ: {1}. Номер (счет): {2}", value, CashOutTypes.GetName(type), TextBoxNumber.Text),
                    WhenDate = DateTime.Now
                };

                DataHelper.AddOperation(operation);
            }

            #endregion

            #region Оплата платежа

            if (cashOut.Value < 1000000) //Qiwi limits
            {
                PaymentHelper.MakePayment(cashOut);
            }

            #endregion

            ResultOrder = 1;

            TextBoxCashOut.Text = string.Empty;
            TextBoxNumber.Text = string.Empty;

            FillList();
        }
    }
}