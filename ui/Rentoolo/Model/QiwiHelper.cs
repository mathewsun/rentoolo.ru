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
            try
            {
                CashIns cashIn = new CashIns
                {
                    UserId = DataHelper.GetUserByPublicId(checkQiwiPayment.UserPublicId).UserId,
                    Value = checkQiwiPayment.Amount,
                    Sposob = "Qiwi",
                    WhenDate = checkQiwiPayment.Date,
                    AcceptedAccount = checkQiwiPayment.AcceptedAccount,
                    SendAccount = checkQiwiPayment.SendAccount
                };

                if (!DataHelper.CheckExistCashIn(cashIn))
                {
                    DataHelper.AddCashIn(cashIn);

                    DataHelper.UpdateUserBalance(cashIn.UserId, CurrenciesEnum.RURT, cashIn.Value, UpdateBalanceType.CashIn);

                    //QiwiHelper.AddQiwiBalanceUpdatePerMonth(checkQiwiPayment.AcceptedAccount, checkQiwiPayment.Amount);

                    #region Логирование операции

                    {
                        Operations operation = new Operations
                        {
                            UserId = cashIn.UserId,
                            Value = cashIn.Value,
                            Type = (int)OperationTypesEnum.AddBalance,
                            Comment =
                                string.Format("Пополнение баланса на сумму {0} р. Способ: 'Qiwi'.",
                                    cashIn.Value),
                            WhenDate = cashIn.WhenDate
                        };

                        DataHelper.AddOperation(operation);
                    }

                    #endregion
                }
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }
        }

        //public static string GetActiveQiwiAcoountNumber()
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        string number = string.Empty;

        //        dc.spGetActiveQiwiAccount(ref number);

        //        return number;
        //    }
        //}

        public static Phones GetQiwiAcoountCashOut(double amount)
        {
            if (amount < 10000)
            {
                using (var ctx = new RentooloEntities())
                {
                    Phones item = ctx.Phones.Where(x => x.Blocked == false && x.Balance < 10000).OrderByDescending(x => x.Balance).FirstOrDefault();

                    if (item != null && item.Balance > amount)
                    {
                        return item;
                    }
                }
            }

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
                Password = "Academy5555"
            };

            return account;
        }

        //public static void CheckCurrentAccountQiwiPaymentsHistory()
        //{
        //    Phones acc = DataHelper.GetQiwiAcoount();

        //    var q = new Model.QiwiCheckHistory();

        //    q.CheckPaymentsHistory(acc.Number, acc.Pwd);
        //}

        public static void CheckQiwiAccountPaymentsHistory(string number)
        {
            //Phones item = QiwiHelper.GetQiwiAcoount(number);

            //var q = new Model.QiwiCheckHistory();

            //q.CheckPaymentsHistory(item.Number, item.Pwd);

            Account account = GetCurrentQiwiAccount();

            var q = new Model.QiwiCheckHistory();

            q.CheckPaymentsHistory(account.Login, account.Password);
        }

        public static void CheckAllAccountsQiwiPaymentsHistories()
        {
            List<Phones> list = QiwiHelper.GetQiwiAcoounts();

            foreach (var item in list)
            {
                var q = new Model.QiwiCheckHistory();

                q.CheckPaymentsHistory(item.Number, item.Pwd);


            }
        }

        public static void UpdateQiwiAccountBalance(string login, double balance)
        {
            using (var dc = new RentooloEntities())
            {
                dc.spUpdateQiwiAccountBalance(login, balance);
            }
        }

        public static void UpdateQiwiAccountBalanceSmallNumber()
        {
            Phones smallQiwi = GetSmallQiwiNumber();

            CheckQiwiAccountPaymentsHistory(smallQiwi.Number);
        }

        public static Phones GetSmallQiwiNumber()
        {
            using (var ctx = new RentooloEntities())
            {
                var item = ctx.Phones.Where(x => x.Blocked == false).OrderBy(x => x.Balance).FirstOrDefault();

                return item;
            }
        }

        public static List<Phones> GetQiwiPhoneNumber()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Phones.OrderByDescending(x => x.Balance).ToList();

                return list;
            }
        }

        //public static void QiwiHistoryChecked(string login)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        dc.spUpdateQiwiAccountWhenHistoryChecked(login);
        //    }
        //}

        #endregion 

    }
}