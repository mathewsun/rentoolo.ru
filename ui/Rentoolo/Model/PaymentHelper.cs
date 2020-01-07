using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QiwiAggregator.Model;

namespace Rentoolo.Model
{
    public static class PaymentHelper
    {
        public static void MakePayment(CashOuts item)
        {
            switch (item.Type)
            {
                case 1:
                    if (QiwiApi.MakePayment(item.Number, item.Value))
                    {
                        DataHelper.UpdateCashOut(item.Id, (int)CashOutStatesEnum.Finished, string.Empty);
                    }
                    break;
                case 2:
                case 3:
                case 4:
                    if (QiwiApi.MakePaymentBankCard(item.Number, item.Value))
                    {
                        DataHelper.UpdateCashOut(item.Id, (int)CashOutStatesEnum.Finished, string.Empty);
                    }
                    break;
                case 5:
                case 100:
                default:
                    break;
            }
        }
    }
}