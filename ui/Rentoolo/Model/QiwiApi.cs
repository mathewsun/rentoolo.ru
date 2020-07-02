using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;
using xNet;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using Rentoolo.Model;

namespace QiwiAggregator.Model
{
    public class QiwiObject
    {

        public QiwiObject()
        {

        }

        public bool auth(string login, string pass)
        {
            bool check = false;

            return check;
        }

        public void CheckQiwiAccountBalance(string login, string pass)
        {

        }

        public bool payments(string account, double amount, string comment = "")
        {
            return false;
        }

        public bool paymentBankCard(string account, double amount)
        {
            return false;
        }

        static string DateTimeToUnixTimestamp(DateTime dateTime)
        {
            TimeSpan span = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc));
            return (span.TotalMilliseconds).ToString("0");
        }
    }

    public static class QiwiApi
    {
        public static bool Payment(QiwiPayment payment)
        {
            return false;
        }

        public static bool PaymentBankCard(QiwiPayment payment)
        {
            return false;
        }

        public static bool MakePayment(string recipient, double amount)
        {
            return false;
        }

        public static bool MakePaymentBankCard(string recipient, double amount)
        {
            return false;
        }
    }
}