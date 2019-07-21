using System;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Payment : BasicPage
    {
        public int PublicId;

        public int ResultOrder = 0;

        public double Balance;

        protected void Page_Load(object sender, EventArgs e)
        {
            PublicId = User.PublicId;
        }

        protected void ButtonMakePayment_Click(object sender, EventArgs e)
        {
            double value;
            if (!double.TryParse(TextBoxPaymentValue.Text, out value))
            {
                ResultOrder = 3;
                return;
            }

            double balance = 0;

            if (balance < value || value <= 0)
            {
                ResultOrder = 2;
                return;
            }

            int userIdRecepient;
            if (!int.TryParse(TextBoxPaymentAddress.Text, out userIdRecepient))
            {
                ResultOrder = 4;
                return;
            }

            Users userRecepient = DataHelper.GetUserByPublicId(userIdRecepient);

            if (userRecepient == null)
            {
                ResultOrder = 5;
                return;
            }

            Model.Payments payment = new Model.Payments
            {
                UserIdSender = User.Id,
                UserIdRecepient = userRecepient.Id,
                Value = value,
                Comment = TextBoxPaymentComment.Text,
                WhenDate = DateTime.Now
            };

            DataHelper.AddPayment(payment);

            #region Списание со счета

            #endregion

            #region Логирование операции перевода от пользователя

            {
                Rentoolo.Model.Operations operation = new Rentoolo.Model.Operations();

                operation.UserId = User.Id;
                operation.Value = -value;
                operation.Type = (int)OperationTypesEnum.PaymentOut;
                operation.Comment = string.Format("Перевод на счёт {0} на сумму {1} р.", TextBoxPaymentAddress.Text, value);

                if (!string.IsNullOrEmpty(TextBoxPaymentComment.Text))
                {
                    operation.Comment = operation.Comment + " Комментарий: " + TextBoxPaymentComment.Text + ".";
                }

                operation.WhenDate = DateTime.Now;

                DataHelper.AddOperation(operation);
            }

            #endregion

            #region Логирование операции получения перевода от другого пользователя

            {
                Rentoolo.Model.Operations operation = new Rentoolo.Model.Operations();

                operation.UserId = userRecepient.Id;
                operation.Value = value;
                operation.Type = (int)OperationTypesEnum.PaymentIn;
                operation.Comment = string.Format("Получен перевод от пользователя на сумму {0} р.", value);

                if (!string.IsNullOrEmpty(TextBoxPaymentComment.Text))
                {
                    operation.Comment = operation.Comment + " Комментарий: " + TextBoxPaymentComment.Text + ".";
                }

                operation.WhenDate = DateTime.Now;

                DataHelper.AddOperation(operation);
            }

            #endregion

            ResultOrder = 1;

            TextBoxPaymentAddress.Text = string.Empty;
            TextBoxPaymentValue.Text = string.Empty;
            TextBoxPaymentComment.Text = string.Empty;
        }
    }
}