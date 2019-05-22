namespace Rentoolo.Model
{
    public enum UpdateBalanceType
    {
        //Пополнение через платежник
        CashIn = 1,

        //Потрачено
        Spend = 4,

        //Доход от реферала
        Refferal = 5,

        //Пополнение от отмены заказа
        CashBack = 6,

        //Перевод от пользователя
        PaymentOut = 7,

        //Перевод пользователю от другого пользователя
        PaymentIn = 8
    }
}