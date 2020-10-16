using Newtonsoft.Json;
using Rentoolo.TestDir;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Rentoolo.Model
{
    public static class DataHelper
    {


        // TODO: reformat Model.edmx


        #region Пользователи

        public static Users GetUser(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                Users user = dc.Users.FirstOrDefault(x => x.UserId == userId);

                return user;
            }
        }


        public static Users GetUser(int userId)
        {
            using (var dc = new RentooloEntities())
            {
                Users user = dc.Users.FirstOrDefault(x => x.Id == userId);

                return user;
            }
        }


        public static Guid GetUserId(string userName)
        {
            using (var dc = new RentooloEntities())
            {
                Guid userId = dc.Users.Where(x => x.UserName == userName).Select(e => e.UserId).FirstOrDefault();

                return userId;
            }
        }

        public static Users GetUserByName(string userName)
        {
            using (var dc = new RentooloEntities())
            {
                Users user = dc.Users.FirstOrDefault(x => x.UserName == userName);

                return user;
            }
        }

        public static Memberships GetUserMembership(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                Memberships membership = dc.Memberships.FirstOrDefault(x => x.UserId == userId);

                return membership;
            }
        }

        public static Users GetUserByRefId(int refId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.PublicId == refId);
                return obj;
            }
        }

        public static void UpdateUser(Users user)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.UserId == user.UserId);
                obj.Pwd = user.Pwd;
                obj.PublicId = user.PublicId;
                obj.Communication = user.Communication;
                ctx.SaveChanges();
            }
        }

        public static void UpdateUserParametr(string userName, string parametr, String parametrValue)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.UserName == userName);

                if (obj != null)
                {
                    if (parametr == "Communication") obj.Communication = parametrValue;

                    ctx.SaveChanges();
                }
            }
        }

        public static void UpdateUserEmail(string userName, string email)
        {
            using (var ctx = new RentooloEntities())
            {
                var item = ctx.Users.FirstOrDefault(x => x.UserName == userName);
                var member = ctx.Memberships.FirstOrDefault(x => x.UserId == item.UserId);
                if (member != null)
                {
                    member.Email = email;
                    ctx.SaveChanges();
                }
            }
        }

        public static void UpdateUserBalance(Guid userId, CurrenciesEnum currency, double balanceAddition, UpdateBalanceType updateType)
        {
            try
            {
                using (var ctx = new RentooloEntities())
                {
                    var obj = ctx.Wallets.FirstOrDefault(x => x.UserId == userId && x.CurrencyId == (int)currency);
                    if (obj != null)
                    {
                        obj.Value = obj.Value + balanceAddition;
                    }
                    else
                    {
                        Wallets wallet = new Wallets();

                        wallet.Value = balanceAddition;
                        wallet.UserId = userId;
                        wallet.CurrencyId = (int)currency;
                        wallet.CreateDate = DateTime.Now;

                        ctx.Wallets.Add(wallet);
                    }

                    ctx.SaveChanges();
                }
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }
        }

        public static List<fnGetAllUsers_Result> GetAllUsers()
        {
            using (var dc = new RentooloEntities())
            {
                List<fnGetAllUsers_Result> list = dc.fnGetAllUsers().OrderByDescending(x => x.CreateDate).ToList();

                return list;
            }
        }

        public static int GetAllUsersCount()
        {
            using (var dc = new RentooloEntities())
            {
                int count = dc.Users.Count();

                return count;
            }
        }

        //public static bool CheckUserInRole(string roleName)
        //{
        //    using (var ctx = new RentooloEntities())
        //    {
        //        var role = ctx.Roles.FirstOrDefault(x => x.Name == roleName);

        //        return ctx.UsersInRole.Any(x => x.Id == role.RoleId);
        //    }
        //}

        public static bool CheckUserAuthorization(string login, string password, string ip, string version)
        {
            bool result = CheckUserAuthorization(login, password);

            if (result)
            {
                LoginStatistics loginStatistic = new LoginStatistics
                {
                    Ip = ip,
                    UserName = login,
                    Client = 1,
                    Version = version,
                    WhenLastDate = DateTime.Now
                };

                AddLoginStatistic(loginStatistic);
            }

            return result;
        }

        public static bool CheckUserAuthorization(string login, string password)
        {
            using (var dc = new RentooloEntities())
            {
                return dc.Users.Any(x => x.UserName == login && x.Pwd == password);
            }
        }

        public static void SetUserLastActivityDate(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                Users obj = dc.Users.Single(x => x.UserId == userId);
                obj.LastActivityDate = DateTime.Now;
                dc.SaveChanges();
            }
        }

        public static void SetUserLastActivityDateByUserName(string userName)
        {
            using (var dc = new RentooloEntities())
            {
                Users obj = dc.Users.Single(x => x.UserName == userName);
                obj.LastActivityDate = DateTime.Now;
                dc.SaveChanges();
            }
        }

        public static void BlockUser(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                Memberships obj = dc.Memberships.Single(x => x.UserId == userId);
                obj.IsLockedOut = true;
                dc.SaveChanges();
            }
        }

        public static void UnBlockUser(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                Memberships obj = dc.Memberships.Single(x => x.UserId == userId);
                obj.IsLockedOut = false;
                dc.SaveChanges();
            }
        }

        #endregion

        #region Статистика входа

        /// <summary>
        /// Добавление значения статистики
        /// Client = 0 - обращение с сайта
        /// Client = 1 - обращение с клиента
        /// </summary>
        public static void AddLoginStatistic(LoginStatistics item)
        {
            using (var ctx = new RentooloEntities())
            {
                if (string.IsNullOrEmpty(item.Version)) item.Version = string.Empty;

                var obj = ctx.LoginStatistics.FirstOrDefault(x => x.UserName == item.UserName && x.Ip == item.Ip && x.Client == item.Client && x.Version == item.Version);

                if (obj != null)
                {
                    obj.Count++;
                    obj.WhenLastDate = item.WhenLastDate;
                }
                else
                {
                    ctx.LoginStatistics.Add(item);
                }

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static LoginStatistics GetLoginStatistic(LoginStatistics item)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.LoginStatistics.FirstOrDefault(x => x.UserName == item.UserName && x.Ip == item.Ip);
                return obj;
            }
        }

        public static List<LoginStatistics> GetLoginStatistics(string userName)
        {
            using (var ctx = new RentooloEntities())
            {
                return ctx.LoginStatistics.Where(x => x.UserName == userName).OrderByDescending(x => x.WhenLastDate).ToList();
            }
        }

        public static int GetLoginStatisticByIp(string ip)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Ip == ip).GroupBy(o => o.UserName).Count();
                return obj;
            }
        }

        public static List<LoginStatistics> GetUsersLoginStatisticsByIp(string ip)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Ip == ip).ToList();
                return obj;
            }
        }

        public static List<LoginStatistics> GetLoginStatisticByClient(int clientId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Client == clientId).OrderBy(x => x.UserName).ToList();
                return obj;
            }
        }

        public static List<LoginStatistics> GetLoginStatisticByClientToday(int clientId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Client == clientId && x.WhenLastDate >= DateTime.Now.AddDays(-1)).OrderByDescending(x => x.WhenLastDate).ToList();
                return obj;
            }
        }

        //---

        public static void AddLoginStat(Guid userId, string ip)
        {
            LoginStat item = new LoginStat
            {
                Ip = ip,
                UserId = userId,
                WhenDate = DateTime.Now
            };

            AddLoginStat(item);
        }

        public static void AddLoginStat(LoginStat item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.LoginStat.Add(item);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static List<LoginStat> GetLoginStat(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                return ctx.LoginStat.Where(x => x.UserId == userId).OrderByDescending(x => x.WhenDate).ToList();
            }
        }

        #endregion

        #region Настройки

        /// <summary>
        /// Получение всех настроек
        /// </summary>
        public static List<Settings> GetAllSettings()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Settings.OrderBy(x => x.Order).ToList();

                return list;
            }
        }

        /// <summary>
        /// Настройка
        /// </summary>
        public static Settings GetSetting(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Settings.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        /// <summary>
        /// Настройка по имени
        /// </summary>
        public static Settings GetSettingByName(string name)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Settings.FirstOrDefault(x => x.Name == name);
                return obj;
            }
        }

        /// <summary>
        /// Сохранение настройки
        /// </summary>
        public static void UpdateSetting(Settings item)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Settings.FirstOrDefault(x => x.Id == item.Id);
                obj.Value = item.Value;
                ctx.SaveChanges();
            }
        }

        public static void UpdateSettingByName(Settings item)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Settings.FirstOrDefault(x => x.Name == item.Name);
                obj.Value = item.Value;
                ctx.SaveChanges();
            }
        }

        #endregion

        #region Пополнение средств

        public static void AddCashIn(CashIns item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.CashIns.Add(item);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static bool CheckExistCashIn(CashIns item)
        {
            using (var ctx = new RentooloEntities())
            {
                return ctx.CashIns.Any(x => x.UserId == item.UserId
                && x.Value == item.Value
                && x.WhenDate == item.WhenDate);
            }
        }

        public static List<CashIns> GetAllCashIns()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.CashIns.Select(x => x).OrderByDescending(x => x.Id).ToList();

                return list;
            }
        }

        public static List<CashIns> GetLast50CashIns()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.CashIns.Select(x => x).OrderByDescending(x => x.Id).Take(50).ToList();

                return list;
            }
        }

        public static List<CashIns> GetUserCashIns(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.CashIns.Where(x => x.UserId == userId).ToList();

                return list;
            }
        }

        public static CashIns GetCashIn(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.CashIns.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void UpdateCashIn(int Id, int state)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.CashIns.Single(x => x.Id == Id);
                obj.WhenDate = DateTime.Now;
                ctx.SaveChanges();
            }
        }

        #endregion

        #region Операции

        /// <summary>
        /// Проведение операции
        /// </summary>
        public static void AddOperation(Operations operation)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Operations.Add(operation);
                ctx.SaveChanges();
            }
        }

        public static List<Operations> GetAllOperations()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Operations.OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static List<Operations> GetLast100Operations()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Operations.OrderByDescending(x => x.Id).Take(100).ToList();
                return obj;
            }
        }

        /// <summary>
        /// Получение операций пользователя
        /// </summary>
        public static List<Operations> GetUserOperations(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Operations.Where(x => x.UserId == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        /// <summary>
        /// Получение операций пользователя
        /// </summary>
        public static List<Operations> GetUserOperationsLast100(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Operations.Where(x => x.UserId == userId).OrderByDescending(x => x.Id).Take(100).ToList();
                return obj;
            }
        }

        #endregion

        #region Рефералы

        public static void AddReferral(Referrals item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Referrals.Add(item);
                ctx.SaveChanges();
            }
        }

        public static List<Referrals> GetAllReferrals()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Referrals.OrderByDescending(x => x.WhenDate).ToList();
                return obj;
            }
        }

        public static List<Referrals> GetUserReferrals(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Referrals.Where(x => x.ReferrerUserId == userId).ToList();
                return obj;
            }
        }

        public static List<fnGetUserReferralsSecondLevel_Result> GetUserReferralsSecondLevel(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.fnGetUserReferralsSecondLevel(userId).ToList();
                return obj;
            }
        }

        public static List<fnGetUserReferralsThirdLevel_Result> GetUserReferralsThirdLevel(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.fnGetUserReferralsThirdLevel(userId).ToList();
                return obj;
            }
        }

        public static int GetUserReferralsCountFirsLavel(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Referrals.Count(x => x.ReferrerUserId == userId);
                return obj;
            }
        }

        public static double GetUserReferralsPercentFirstLevel()
        {
            using (var ctx = new RentooloEntities())
            {
                double result = 0;
                Settings obj = ctx.Settings.FirstOrDefault(x => x.Name == "ReferralPercent");
                Double.TryParse(obj.Value, out result);
                return result;
            }
        }

        public static string GetUserReferralsPercentSecondLevel()
        {
            using (var ctx = new RentooloEntities())
            {
                Settings obj = ctx.Settings.FirstOrDefault(x => x.Name == "ReferralPercent2");
                return obj.Value;
            }
        }

        public static string GetUserReferralsPercentThirdLevel()
        {
            using (var ctx = new RentooloEntities())
            {
                Settings obj = ctx.Settings.FirstOrDefault(x => x.Name == "ReferralPercent3");
                return obj.Value;
            }
        }

        //public static double GetUserReferralsBonus(Guid userId)
        //{
        //    using (var ctx = new RentooloEntities())
        //    {
        //        var obj = ctx.fnGetReferralBonus(userId);
        //        return obj.HasValue ? obj.Value : 0;
        //    }
        //}

        public static Referrals GetReferral(Guid referralId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Referrals.SingleOrDefault(x => x.ReferralUserId == referralId);
                return obj;
            }
        }

        public static Users GetUserByPublicId(int publicId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.PublicId == publicId);
                return obj;
            }
        }

        public static int GenerateUserPublicId()
        {
            Random rnd = new Random();
            int publicId = 0;

            bool result = false;

            while (!result)
            {
                publicId = rnd.Next(0, 1000000);

                if (GetUserByPublicId(publicId) == null)
                    result = true;
            }

            return publicId;
        }

        #endregion

        #region Новости

        public static List<News> GetNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.News.Where(x => x.Date <= DateTime.Now).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static List<News> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.News.Where(x => x.Active.HasValue && x.Active.Value).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static List<News> GetActiveNewsLast5()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.News.Where(x => x.Active.HasValue && x.Active.Value).OrderByDescending(x => x.Date).Take(5).ToList();

                return list;
            }
        }

        public static News GetOneNews(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.News.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void SubmitNews(News item)
        {
            using (var ctx = new RentooloEntities())
            {
                if (item.Id == 0)
                {
                    ctx.News.Add(item);
                }
                else
                {
                    var obj = ctx.News.Single(x => x.Id == item.Id);
                    obj.Date = item.Date;
                    obj.Text = item.Text;
                    obj.CreateDate = item.CreateDate;
                    obj.AuthorId = item.AuthorId;
                    obj.Active = item.Active;
                }

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }
        public static void DeleteNews(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                News obj = ctx.News.Single(x => x.Id == id);

                ctx.News.Remove(obj);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        #endregion

        #region Статьи

        public static List<Articles> GetArticles()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Articles.OrderByDescending(x => x.WhenDate).ToList();

                return list;
            }
        }

        public static Articles GetOneArticle(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Articles.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void SubmitArticle(Articles item)
        {
            using (var ctx = new RentooloEntities())
            {
                if (item.Id == 0)
                {
                    ctx.Articles.Add(item);
                }
                else
                {
                    var obj = ctx.Articles.Single(x => x.Id == item.Id);
                    obj.WhenDate = item.WhenDate;
                    obj.Head = item.Head;
                    obj.Text = item.Text;
                    obj.UserId = item.UserId;
                }

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static void DeleteArticle(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                Articles obj = ctx.Articles.Single(x => x.Id == id);

                ctx.Articles.Remove(obj);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        #endregion

        #region Исключения

        public static List<Exceptions> GetExceptions()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Exceptions.OrderByDescending(x => x.Id).ToList();

                return list;
            }
        }

        public static List<Exceptions> GetExceptionsLast100()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Exceptions.OrderByDescending(x => x.Id).Take(100).ToList();

                return list;
            }
        }

        public static void AddException(System.Exception ex)
        {
            Exceptions exception = new Exceptions();

            exception.Value = ex.Message;
            exception.WhenDate = DateTime.Now;

            using (var ctx = new RentooloEntities())
            {
                ctx.Exceptions.Add(exception);
                ctx.SaveChanges();
            }
        }

        #endregion

        #region Пополнения баланса

        //public static string GetHash(string val)
        //{
        //    SHA1 sha = new SHA1CryptoServiceProvider();
        //    byte[] data = sha.ComputeHash(Encoding.Default.GetBytes(val));

        //    StringBuilder sBuilder = new StringBuilder();

        //    for (int i = 0; i < data.Length; i++)
        //    {
        //        sBuilder.Append(data[i].ToString("x2"));
        //    }
        //    return sBuilder.ToString();
        //}

        #endregion

        #region Вывод

        /// <summary>
        /// Создание вывода
        /// </summary>
        public static int AddCashOut(CashOuts item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.CashOuts.Add(item);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);

                    return 0;
                }

                return item.Id;
            }
        }

        public static List<CashOuts> GetUser50CashOuts(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.CashOuts.Where(x => x.UserId == userId).OrderByDescending(x => x.WhenDate).Take(50).ToList();

                return list;
            }
        }

        public static List<CashOuts> GetAllCashOuts()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.CashOuts.Select(x => x).OrderByDescending(x => x.Id).Take(100).ToList();

                return list;
            }
        }

        /// <summary>
        /// Вывод
        /// </summary>
        public static CashOuts GetCashOut(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.CashOuts.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void UpdateUserCashOut(int Id, Guid userId, int state, string comment)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.CashOuts.Single(x => x.Id == Id && x.UserId == userId);
                obj.State = state;
                obj.Comment = comment;
                obj.WhenAdminEvent = DateTime.Now;
                ctx.SaveChanges();
            }
        }

        public static void UpdateCashOut(int Id, int state, string comment)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.CashOuts.Single(x => x.Id == Id);
                obj.State = state;
                obj.Comment = comment;
                obj.WhenAdminEvent = DateTime.Now;
                ctx.SaveChanges();
            }
        }

        public static CashOuts GetCashOutForPayment()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.CashOuts.Where(x => x.State == 1 && x.Result == 1).FirstOrDefault();
                return obj;
            }
        }
        #endregion

        #region Администрирование

        public static List<fnGetTablesRows_Result> GetTablesRowsCount()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.fnGetTablesRows().OrderByDescending(x => x.RowCount).ToList();

                return list;
            }
        }

        public static int GetLoginStatisticLastHourActive()
        {
            using (var ctx = new RentooloEntities())
            {
                int result = ctx.spGetLoginStatisticLastHourActive();
                return result;
            }
        }

        public static int GetLoginStatisticLastDayActive()
        {
            using (var ctx = new RentooloEntities())
            {
                int result = ctx.spGetLoginStatisticLastDayActive();
                return result;
            }
        }
        #endregion

        #region Платежи

        public static void AddPayment(Payments item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Payments.Add(item);
                ctx.SaveChanges();
            }
        }

        public static List<Payments> GetLast100Payments()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Payments.OrderByDescending(x => x.Id).Take(100).ToList();
                return obj;
            }
        }

        public static List<Payments> GetUserSenderPayments(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Payments.Where(x => x.UserIdSender == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static List<Payments> GetUserRecepientPayments(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.Payments.Where(x => x.UserIdRecepient == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        #endregion



        #region UserViews

        public static void TryAddUserView(UserViews userView)
        {
            using (var dc = new RentooloEntities())
            {
                var views = dc.UserViews.Where(x => x.UserId == userView.UserId).OrderBy(x => x.Date);
                if (views.Any())
                {
                    int count = views.Count();

                    if ((views.ToArray()[count - 1].Date.Date - DateTime.Now.Date).Days >= 1)
                    {
                        dc.UserViews.Add(userView);
                        dc.SaveChanges();
                    }
                }
                else
                {
                    dc.UserViews.Add(userView);
                    dc.SaveChanges();
                }

            }
        }


        public static int GetUserViewsCount(int objectId, int type)
        {
            using (var dc = new RentooloEntities())
            {

                return dc.UserViews.Where(x => (x.ObjectId == objectId) && (x.Type == type)).Count();
            }
        }




        #endregion


        #region Comments

        public static void AddComment(Comments comment)
        {
            using (var dc = new RentooloEntities())
            {
                dc.Comments.Add(comment);
                dc.SaveChanges();
            }
        }


        //public static List<Comments> GetComments(int type, int advertId)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        return dc.Comments.Where(x => (x.Type == type) && (x.AdvertId == advertId)).ToList();
        //    }
        //}

        // comment id
        public static void UpdateCommentLikes(int id)
        {
            using (var dc = new RentooloEntities())
            {
                dc.Comments.First(x => x.Id == id).Likes += 1;
                dc.SaveChanges();
            }
        }

        // comment id
        public static void UpdateCommentDisLikes(int id)
        {
            using (var dc = new RentooloEntities())
            {
                dc.Comments.First(x => x.Id == id).DisLikes += 1;
                dc.SaveChanges();
            }
        }


        #endregion


        #region Likes/DisLikes


        #region have like/dislike

        public static bool HaveUserLike(Guid userId, int commentId)
        {
            using (var dc = new RentooloEntities())
            {
                var like = dc.Likes.FirstOrDefault(x => (x.CommentId == commentId) && (x.UserId == userId));
                bool haveLiked = like == null ? false : true;
                return haveLiked;
            }
        }


        public static bool HaveUserDisLike(Guid userId, int commentId)
        {
            using (var dc = new RentooloEntities())
            {
                var like = dc.DisLikes.FirstOrDefault(x => (x.CommentId == commentId) && (x.UserId == userId));
                bool haveDisLiked = like == null ? false : true;
                return haveDisLiked;
            }
        }


        #endregion


        public static int GetLikesCount(int commentId)
        {
            using (var dc = new RentooloEntities())
            {
                var count = dc.Likes.Count(x => x.CommentId == commentId);
                return count;
            }
        }

        public static int GetDisLikesCount(int commentId)
        {
            using (var dc = new RentooloEntities())
            {
                var count = dc.DisLikes.Count(x => x.CommentId == commentId);
                return count;
            }
        }




        public static void LikeUnLike(Guid userId, int commentId)
        {
            using (var dc = new RentooloEntities())
            {
                if (HaveUserLike(userId, commentId))
                {
                    Likes like = dc.Likes.Where(x => (x.CommentId == commentId) && (x.UserId == userId)).First();
                    dc.Likes.Remove(like);
                }
                else
                {
                    if (HaveUserDisLike(userId, commentId))
                    {
                        // убирает дизлайк
                        DisLikeUnDisLike(userId, commentId);
                    }

                    dc.Likes.Add(new Likes() { UserId = userId, CommentId = commentId });

                }
                dc.SaveChanges();
            }
        }

        public static void DisLikeUnDisLike(Guid userId, int commentId)
        {
            using (var dc = new RentooloEntities())
            {
                if (HaveUserDisLike(userId, commentId))
                {
                    var dislike = dc.DisLikes.First(x => (x.UserId == userId) && (x.CommentId == commentId));
                    dc.DisLikes.Remove(dislike);
                }
                else
                {
                    if (HaveUserLike(userId, commentId))
                    {
                        // убирает лайк
                        LikeUnLike(userId, commentId);
                    }

                    dc.DisLikes.Add(new DisLikes() { UserId = userId, CommentId = commentId });

                }
                dc.SaveChanges();
            }
        }


        #endregion

        #region Comments

        //public static List<spGetComments_Result> GetComments_Results(long objId, Guid userId)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        List<spGetComments_Result> result = dc.spGetComments(objId, userId).ToList();
                
        //        return result;
        //    }
        //}


        public static List<spGetCommentsForUser_Result> spGetCommentsForUser(Guid userId, int advertId)
        {
            using (var dc = new RentooloEntities())
            {
                var result = dc.spGetCommentsForUser(userId, advertId).ToList();

                return result;
            }
        }

        #endregion

        #region CommentsTestVarkent

        //public static List<spGetCommentsTestVarkent_Result> spGetCommentsTestVarkent_Results(long objId, Guid userId)
        //{  
        //    using (var dc1 = new RentooloEntities())
        //    {
        //        List<spGetCommentsTestVarkent_Result> result1 = dc1.spGetCommentsTestVarkent(objId, userId).ToList();
                
        //        return result1;
        //    }
        //}
        #endregion


        // TODO: переписать сложные linq запросы на хранимые процедуры в БД

            // dialogs deprecated
        #region Dialogs

        //public static void CreateDialog(Guid user1, Guid user2)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        dc.DialogsInfo.Add(new DialogsInfo { User1Id = user1, User2Id = user2 });
        //        dc.SaveChanges();
        //    }
        //}


        //public static void SaveNewMessage(Guid userId, Int64 dialogId, string message)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        dc.DialogMessages.Add(new DialogMessages() { FromUserId = userId, DialogInfoId = dialogId, Message = message, Date = DateTime.Now });
        //        dc.SaveChanges();
        //    }
        //}

        //public static void SaveNewMessage(DialogMessages msg)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        msg.Date = DateTime.Now;
        //        dc.DialogMessages.Add(msg);
        //        dc.SaveChanges();

        //        var dialog = dc.DialogsInfo.First(x => x.Id == msg.DialogInfoId);


        //        var activeUsers = dc.DialogActiveUsers.Where(x => (x.UserId == dialog.User1Id) || (x.UserId == dialog.User2Id));

        //        // TODO: разобраться почему несколько раз отправляется

        //        foreach(var user in activeUsers)
        //        {
        //            WSServer.SendMessageToUser(user.UserId.ToString(), JsonConvert.SerializeObject(msg));
        //        }



        //    }
        //}



        //public static void AddActiveWSUser(DialogActiveUsers user)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        dc.DialogActiveUsers.Add(user);
        //        dc.SaveChanges();
        //    }
        //}

        //public static void RemoveActiveWSUser(Guid userId)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        var activeUser = dc.DialogActiveUsers.First(x => x.UserId == userId);
        //        dc.DialogActiveUsers.Remove(activeUser);
        //        dc.SaveChanges();
        //    }
        //}




        //public static bool GetActiveDialogUser(Guid userId)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        var user =  dc.DialogActiveUsers.FirstOrDefault(x => x.UserId == userId);
        //        bool isActive = user == null ? false : true;
        //        return isActive;
        //    }
        //} 







        //public static List<DialogMessages> GetMessages(Int64 dialogId, int skipCount = 0)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        var messages = dc.DialogMessages.Select(x => x).OrderBy(x=>x.Date).Skip(skipCount);
        //        return messages.ToList();
        //    }
        //}

        //public static List<DialogsInfo> GetDialogs(Guid userId)
        //{
        //    using (var dc = new RentooloEntities())
        //    {
        //        var chats = dc.DialogsInfo.Where(x => (x.User1Id == userId) || (x.User2Id == userId));
        //        return chats.ToList();
        //    }
        //}


        //public static List<ViewedDialogInfo> GetViwedDialogs(Guid userId)
        //{
        //    // выбор DialogInfo и преобразование типа в  ViewedDialogInfo
        //    // с вычислением названия диалога(диалог называется как в ВК по имени собеседника 
        //    using (var dc = new RentooloEntities())
        //    {
        //        IQueryable<ViewedDialogInfo> vChats = (IQueryable<ViewedDialogInfo>)

        //            (from x in dc.DialogsInfo where (x.User1Id == userId) || (x.User2Id == userId)

        //             select new ViewedDialogInfo()
        //             {
        //                 Id = x.Id, DialogName = x.User1Id==userId ?

        //                 dc.Users.First(u=>u.UserId==x.User2Id).UserName : dc.Users.First(u => u.UserId == x.User1Id).UserName

        //                 //    (x.User1Id == userId ?
        //                 //new ViewedDialogInfo() { Id = x.Id, DialogName = dc.Users.First(y => y.UserId == x.User2Id).UserName }
        //                 //: new ViewedDialogInfo() { Id = x.Id, DialogName = dc.Users.First(y => y.UserId == x.User1Id).UserName })
        //             });

        //        return vChats.ToList();

        //    }
        //}




        #endregion


        #region Chats


        public static List<spGetChatsForUser_Result> GetChatsForUser(Guid userId, int skipCount = 0)
        {
            using (var dc = new RentooloEntities())
            {
                return dc.spGetChatsForUser(userId).ToList();
            }
        }



        public static void AddActiveWSUser(ChatActiveUsers user)
        {
            using (var dc = new RentooloEntities())
            {
                dc.ChatActiveUsers.Add(user);
                dc.SaveChanges();
            }
        }

        public static void RemoveChatActiveWSUser(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                var activeUser = dc.ChatActiveUsers.First(x => x.UserId == userId);
                dc.ChatActiveUsers.Remove(activeUser);
                dc.SaveChanges();
            }
        }





        public static void CreateChatDialog(Chats chatInfo, Guid anotherUserId)
        {
            using (var dc = new RentooloEntities())
            {
                dc.Chats.Add(chatInfo);
                dc.SaveChanges();

                long chatId = dc.Chats.First(x => x.Id == chatInfo.Id).Id;

                dc.ChatUsers.Add(new ChatUsers() { UserId = anotherUserId, ChatId = chatId });
                dc.ChatUsers.Add(new ChatUsers() { UserId = chatInfo.OwnerId, ChatId = chatId });

                dc.SaveChanges();
            }
        }



        public static void CreateChat(Chats chatInfo)
        {
            using (var dc = new RentooloEntities())
            {
                dc.Chats.Add(chatInfo);
                dc.ChatUsers.Add(new ChatUsers() { UserId = chatInfo.OwnerId, ChatId = chatInfo.Id });
                dc.SaveChanges();

                long chatId = dc.Chats.First(x => x.Id == chatInfo.Id).Id;
                dc.ChatUsers.Add(new ChatUsers() { UserId = chatInfo.OwnerId, ChatId = chatId });
                dc.SaveChanges();
            }
        }

        

        public static List<Chats> GetChats(Guid userId ,int skipCount = 0)
        {
            using (var dc = new RentooloEntities())
            {
                var chatIds = dc.ChatUsers.Where(x => x.UserId == userId).Select(x => x.Id).ToList();
                var chats = dc.Chats.Where(x => chatIds.Contains(x.Id));
                return chats.ToList();
            }
        }

        


        public static void AddChatUser(ChatUsers chatUser)
        {
            using (var dc = new RentooloEntities())
            {
                dc.ChatUsers.Add(chatUser);
                dc.SaveChanges();
            }
        }




        public static List<ChatMessages> GetChatMessages(long chatId)
        {
            using (var dc = new RentooloEntities())
            {
                return dc.ChatMessages.Where(x => x.ChatId == chatId).ToList();
            }

        }


        public static void SaveChatMessage(ChatMessages message)
        {
            using (var dc = new RentooloEntities())
            {
                message.Date = DateTime.Now;
                dc.ChatMessages.Add(message);
                dc.SaveChanges();


                

                var activeUsers = dc.ChatActiveUsers.Where(x => x.ChatId == message.ChatId).ToArray();

                // TODO: разобраться почему несколько раз отправляется

                foreach (var user in activeUsers)
                {
                    WSServer.SendMessageToUser(user.UserId.ToString(), JsonConvert.SerializeObject(message));
                }
            }
        }




        //public static List<ViewedChat> GetViewedChats(Guid userId)
        //{
        //    var dialogs = GetViwedDialogs(userId);
        //    var chats = GetChats(userId);

        //    List<ViewedChat> viewedChats = new List<ViewedChat>();

        //    viewedChats.AddRange(dialogs.Select(x => new ViewedChat(x)));
        //    viewedChats.AddRange(chats.Select(x => new ViewedChat(x)));

        //    return viewedChats;
        //}







        #endregion

    }
}