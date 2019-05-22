using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public enum CashOutTypesEnum
    {
        Qiwi = 1,

        Yandex = 2,

        WebMoney = 3,

        BankCard = 4,

        Payer = 5,

        Other = 100
    }

    public static class CashOutTypes
    {
        public static string GetName(int value)
        {
            string name = "Нет такой операции";

            switch ((CashOutTypesEnum)value)
            {
                case CashOutTypesEnum.Qiwi:
                    name = "Qiwi";
                    break;
                case CashOutTypesEnum.Yandex:
                    name = "Yandex";
                    break;
                case CashOutTypesEnum.WebMoney:
                    name = "WebMoney";
                    break;
                case CashOutTypesEnum.BankCard:
                    name = "BankCard";
                    break;
                case CashOutTypesEnum.Payer:
                    name = "Payer";
                    break;
                case CashOutTypesEnum.Other:
                    name = "Другой";
                    break;
            }

            return name;
        }
    }
}