using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Rentoolo.Model
{
    public static class DataHelper
    {
        #region Пользователи

        public static Users GetUser(Guid userId)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Users user = dc.Users.FirstOrDefault(x => x.UserId == userId);

                return user;
            }
        }

        public static Guid GetUserId(string userName)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Guid userId = dc.Users.Where(x => x.UserName == userName).Select(e => e.UserId).FirstOrDefault();

                return userId;
            }
        }

        public static Users GetUserByName(string userName)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Users user = dc.Users.FirstOrDefault(x => x.UserName == userName);

                return user;
            }
        }

        public static Memberships GetUserMembership(Guid userId)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Memberships membership = dc.Memberships.FirstOrDefault(x => x.UserId == userId);

                return membership;
            }
        }

        public static Users GetUserByRefId(int refId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.PublicId == refId);
                return obj;
            }
        }

        public static void UpdateUser(Users user)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.UserId == user.UserId);
                obj.Pwd = user.Pwd;
                obj.PublicId = user.PublicId;
                obj.Communication = user.Communication;
                ctx.SubmitChanges();
            }
        }

        public static void UpdateUserParametr(string userName, string parametr, String parametrValue)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Users.FirstOrDefault(x => x.UserName == userName);

                if (obj != null)
                {
                    if (parametr == "Communication") obj.Communication = parametrValue;

                    ctx.SubmitChanges();
                }
            }
        }

        public static void UpdateUserEmail(string userName, string email)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var item = ctx.Users.FirstOrDefault(x => x.UserName == userName);
                var member = ctx.Memberships.FirstOrDefault(x => x.UserId == item.UserId);
                if (member != null)
                {
                    member.Email = email;
                    ctx.SubmitChanges();
                }
            }
        }

        public static List<fnGetAllUsersResult> GetAllUsers()
        {
            using (var dc = new DataClasses1DataContext())
            {
                List<fnGetAllUsersResult> list = dc.fnGetAllUsers().OrderByDescending(x => x.CreateDate).ToList();

                return list;
            }
        }

        public static int GetAllUsersCount()
        {
            using (var dc = new DataClasses1DataContext())
            {
                int count = dc.Users.Count();

                return count;
            }
        }

        public static bool CheckUserInRole(string roleName)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var role = ctx.Roles.FirstOrDefault(x => x.RoleName == roleName);

                return ctx.UsersInRoles.Any(x => x.Role == role);
            }
        }

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
            using (var dc = new DataClasses1DataContext())
            {
                return dc.Users.Any(x => x.UserName == login && x.Pwd == password);
            }
        }

        public static void SetUserLastActivityDate(Guid userId)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Users obj = dc.Users.Single(x => x.UserId == userId);
                obj.LastActivityDate = DateTime.Now;
                dc.SubmitChanges();
            }
        }

        public static void SetUserLastActivityDateByUserName(string userName)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Users obj = dc.Users.Single(x => x.UserName == userName);
                obj.LastActivityDate = DateTime.Now;
                dc.SubmitChanges();
            }
        }

        public static void BlockUser(Guid userId)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Memberships obj = dc.Memberships.Single(x => x.UserId == userId);
                obj.IsLockedOut = true;
                dc.SubmitChanges();
            }
        }

        public static void UnBlockUser(Guid userId)
        {
            using (var dc = new DataClasses1DataContext())
            {
                Memberships obj = dc.Memberships.Single(x => x.UserId == userId);
                obj.IsLockedOut = false;
                dc.SubmitChanges();
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
            using (var ctx = new DataClasses1DataContext())
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
                    ctx.LoginStatistics.InsertOnSubmit(item);
                }

                try
                {
                    ctx.SubmitChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static LoginStatistics GetLoginStatistic(LoginStatistics item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.LoginStatistics.FirstOrDefault(x => x.UserName == item.UserName && x.Ip == item.Ip);
                return obj;
            }
        }

        public static List<LoginStatistics> GetLoginStatistics(string userName)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                return ctx.LoginStatistics.Where(x => x.UserName == userName).OrderByDescending(x => x.WhenLastDate).ToList();
            }
        }

        public static int GetLoginStatisticByIp(string ip)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Ip == ip).GroupBy(o => o.UserName).Count();
                return obj;
            }
        }

        public static List<LoginStatistics> GetUsersLoginStatisticsByIp(string ip)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Ip == ip).ToList();
                return obj;
            }
        }

        public static List<LoginStatistics> GetLoginStatisticByClient(int clientId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Client == clientId).OrderBy(x => x.UserName).ToList();
                return obj;
            }
        }

        public static List<LoginStatistics> GetLoginStatisticByClientToday(int clientId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.LoginStatistics.Where(x => x.Client == clientId && x.WhenLastDate >= DateTime.Now.AddDays(-1)).OrderByDescending(x => x.WhenLastDate).ToList();
                return obj;
            }
        }

        #endregion

        #region Настройки

        /// <summary>
        /// Получение всех настроек
        /// </summary>
        public static List<Settings> GetAllSettings()
        {
            using (var ctx = new DataClasses1DataContext())
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
            using (var ctx = new DataClasses1DataContext())
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
            using (var ctx = new DataClasses1DataContext())
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
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Settings.FirstOrDefault(x => x.Id == item.Id);
                obj.Value = item.Value;
                ctx.SubmitChanges();
            }
        }

        #endregion

        #region Пополнение средств

        public static void AddCashIn(CashIns item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                ctx.CashIns.InsertOnSubmit(item);

                try
                {
                    ctx.SubmitChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static bool CheckExistCashIn(CashIns item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                return ctx.CashIns.Any(x => x.UserId == item.UserId
                && x.Value == item.Value
                && x.WhenDate == item.WhenDate);
            }
        }

        public static List<CashIns> GetAllCashIns()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.CashIns.Select(x => x).OrderByDescending(x => x.Id).ToList();

                return list;
            }
        }

        public static List<CashIns> GetLast50CashIns()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.CashIns.Select(x => x).OrderByDescending(x => x.Id).Take(50).ToList();

                return list;
            }
        }

        public static List<CashIns> GetUserCashIns(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.CashIns.Where(x => x.UserId == userId).ToList();

                return list;
            }
        }

        public static CashIns GetCashIn(int id)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.CashIns.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void UpdateCashIn(int Id, int state)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.CashIns.Single(x => x.Id == Id);
                obj.WhenDate = DateTime.Now;
                ctx.SubmitChanges();
            }
        }

        #endregion

        #region Операции

        /// <summary>
        /// Проведение операции
        /// </summary>
        public static void AddOperation(Operation operation)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                ctx.Operations.InsertOnSubmit(operation);
                ctx.SubmitChanges();
            }
        }

        public static List<Operation> GetAllOperations()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Operations.OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static List<Operation> GetLast100Operations()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Operations.OrderByDescending(x => x.Id).Take(100).ToList();
                return obj;
            }
        }

        /// <summary>
        /// Получение операций пользователя
        /// </summary>
        public static List<Operation> GetUserOperations(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Operations.Where(x => x.UserId == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        /// <summary>
        /// Получение операций пользователя
        /// </summary>
        public static List<Operation> GetUserOperationsLast100(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Operations.Where(x => x.UserId == userId).OrderByDescending(x => x.Id).Take(100).ToList();
                return obj;
            }
        }

        #endregion

        #region Рефералы

        public static void AddReferral(Referrals item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                ctx.Referrals.InsertOnSubmit(item);
                ctx.SubmitChanges();
            }
        }

        public static List<Referrals> GetAllReferrals()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Referrals.OrderByDescending(x => x.WhenDate).ToList();
                return obj;
            }
        }

        public static List<Referrals> GetUserReferrals(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Referrals.Where(x => x.ReferrerUserId == userId).ToList();
                return obj;
            }
        }

        public static List<fnGetUserReferralsSecondLevelResult> GetUserReferralsSecondLevel(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.fnGetUserReferralsSecondLevel(userId).ToList();
                return obj;
            }
        }

        public static List<fnGetUserReferralsThirdLevelResult> GetUserReferralsThirdLevel(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.fnGetUserReferralsThirdLevel(userId).ToList();
                return obj;
            }
        }

        public static int GetUserReferralsCountFirsLavel(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Referrals.Count(x => x.ReferrerUserId == userId);
                return obj;
            }
        }

        public static double GetUserReferralsPercentFirstLevel()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                double result = 0;
                Settings obj = ctx.Settings.FirstOrDefault(x => x.Name == "ReferralPercent");
                Double.TryParse(obj.Value, out result);
                return result;
            }
        }

        public static string GetUserReferralsPercentSecondLevel()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                Settings obj = ctx.Settings.FirstOrDefault(x => x.Name == "ReferralPercent2");
                return obj.Value;
            }
        }

        public static string GetUserReferralsPercentThirdLevel()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                Settings obj = ctx.Settings.FirstOrDefault(x => x.Name == "ReferralPercent3");
                return obj.Value;
            }
        }

        public static double GetUserReferralsBonus(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.fnGetReferralBonus(userId);
                return obj.HasValue ? obj.Value : 0;
            }
        }

        public static Referrals GetReferral(Guid referralId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Referrals.SingleOrDefault(x => x.ReferralUserId == referralId);
                return obj;
            }
        }

        public static Users GetUserByPublicId(int publicId)
        {
            using (var ctx = new DataClasses1DataContext())
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

        public static List<New> GetNews()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.News.Where(x => x.Date <= DateTime.Now).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static List<New> GetActiveNews()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.News.Where(x => x.Active.HasValue && x.Active.Value).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static List<New> GetActiveNewsLast5()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.News.Where(x => x.Active.HasValue && x.Active.Value).OrderByDescending(x => x.Date).Take(5).ToList();

                return list;
            }
        }

        public static New GetOneNews(int id)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.News.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void SubmitNews(New item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                if (item.Id == 0)
                {
                    ctx.News.InsertOnSubmit(item);
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
                    ctx.SubmitChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }
        public static void DeleteNews(int id)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                New obj = ctx.News.Single(x => x.Id == id);

                ctx.News.DeleteOnSubmit(obj);

                try
                {
                    ctx.SubmitChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        #endregion

        #region Статьи

        public static List<Article> GetArticles()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.Articles.OrderByDescending(x => x.WhenDate).ToList();

                return list;
            }
        }

        public static Article GetOneArticle(int id)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Articles.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void SubmitArticle(Article item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                if (item.Id == 0)
                {
                    ctx.Articles.InsertOnSubmit(item);
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
                    ctx.SubmitChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static void DeleteArticle(int id)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                Article obj = ctx.Articles.Single(x => x.Id == id);

                ctx.Articles.DeleteOnSubmit(obj);

                try
                {
                    ctx.SubmitChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        #endregion

        #region Исключения

        public static List<Exception> GetExceptions()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.Exceptions.OrderByDescending(x => x.Id).ToList();

                return list;
            }
        }

        public static List<Exception> GetExceptionsLast100()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.Exceptions.OrderByDescending(x => x.Id).Take(100).ToList();

                return list;
            }
        }

        public static void AddException(System.Exception ex)
        {
            Exception exception = new Exception();

            exception.Value = ex.Message;
            exception.WhenDate = DateTime.Now;

            using (var ctx = new DataClasses1DataContext())
            {
                ctx.Exceptions.InsertOnSubmit(exception);
                ctx.SubmitChanges();
            }
        }

        #endregion

        #region Пополнения баланса

        public static void AddQiwiBalanceUpdatePerMonth(string login, double amount)
        {
            using (var dc = new DataClasses1DataContext())
            {
                dc.spAddQiwiBalanceUpdatePerMonth(login, amount);
            }
        }

        public static void AddQiwiPayment(int userPublicId, double amount, DateTime date, string acceptedAccount)
        {
            try
            {
                CashIns cashIn = new CashIns
                {
                    UserId = DataHelper.GetUserByPublicId(userPublicId).UserId,
                    Value = amount,
                    Sposob = "Qiwi",
                    WhenDate = date,
                    AcceptedAccount = acceptedAccount
                };

                if (!CheckExistCashIn(cashIn))
                {
                    AddCashIn(cashIn);

                    DataHelper.AddQiwiBalanceUpdatePerMonth(acceptedAccount, amount);

                    #region Логирование операции

                    {
                        Operation operation = new Operation
                        {
                            UserId = cashIn.UserId,
                            Value = cashIn.Value,
                            Type = (int)OperationTypesEnum.AddBalance,
                            Comment =
                                string.Format("Пополнение RURT на сумму {0} р. Способ: 'Qiwi'.",
                                    cashIn.Value),
                            WhenDate = cashIn.WhenDate
                        };

                        AddOperation(operation);
                    }

                    #endregion
                }
            }
            catch (System.Exception ex)
            {
                AddException(ex);
            }
        }

        public static string GetHash(string val)
        {
            SHA1 sha = new SHA1CryptoServiceProvider();
            byte[] data = sha.ComputeHash(Encoding.Default.GetBytes(val));

            StringBuilder sBuilder = new StringBuilder();

            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }

        #endregion

        #region Администрирование

        public static List<fnGetTablesRowsResult> GetTablesRowsCount()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.fnGetTablesRows().OrderByDescending(x => x.RowCount).ToList();

                return list;
            }
        }

        public static int GetLoginStatisticLastHourActive()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                int result = ctx.spGetLoginStatisticLastHourActive();
                return result;
            }
        }

        public static int GetLoginStatisticLastDayActive()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                int result = ctx.spGetLoginStatisticLastDayActive();
                return result;
            }
        }
        #endregion

        #region Платежи

        public static void AddPayment(Payments item)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                ctx.Payments.InsertOnSubmit(item);
                ctx.SubmitChanges();
            }
        }

        public static List<Payments> GetLast100Payments()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Payments.OrderByDescending(x => x.Id).Take(100).ToList();
                return obj;
            }
        }

        public static List<Payments> GetUserSenderPayments(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Payments.Where(x => x.UserIdSender == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static List<Payments> GetUserRecepientPayments(Guid userId)
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var obj = ctx.Payments.Where(x => x.UserIdRecepient == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        #endregion
    }
}