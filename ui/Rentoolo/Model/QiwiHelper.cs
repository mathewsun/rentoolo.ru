using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace Rentoolo.Model
{
    public static class QiwiHelper
    {

        #region Qiwi

        public static void AddQiwiPayment(CheckQiwiPayment checkQiwiPayment)
        {

        }

        public static Phones GetQiwiAcoountCashOut(double amount)
        {
            using (var ctx = new RentooloEntities())
            {
                Phones item = ctx.Phones.Where(x => x.Blocked == false).OrderByDescending(x => x.Balance).FirstOrDefault();

                return item;
            }
        }
        public static Phones GetQiwiAcoount(string number)
        {
            using (var ctx = new RentooloEntities())
            {
                Phones item = ctx.Phones.FirstOrDefault(x => x.Number == number);

                return item;
            }
        }
        public static List<Phones> GetQiwiAcoounts()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Phones.Where(x => x.Blocked == false).ToList();

                return list;
            }
        }

        public static Account GetCurrentQiwiAccount()
        {
            Account account = new Account
            {
                Login = "79686399088",
                Password = "111"
            };

            return account;
        }

        public static void CheckQiwiAccountPaymentsHistory(string number)
        {

        }

        public static void CheckAllAccountsQiwiPaymentsHistories()
        {

        }

        public static void UpdateQiwiAccountBalance(string login, double balance)
        {

        }

        public static void UpdateQiwiAccountBalanceSmallNumber()
        {

        }

        public static List<Phones> GetQiwiPhoneNumber()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Phones.OrderByDescending(x => x.Balance).ToList();

                return list;
            }
        }

        #endregion

    }
}