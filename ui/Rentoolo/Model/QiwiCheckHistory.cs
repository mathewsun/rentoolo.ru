using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;
using xNet;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace Rentoolo.Model
{
    public class QiwiCheckHistory
    {
        CookieDictionary MyCokies;

        string UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36 OPR/43.0.2442.991";

        HttpRequest def = new HttpRequest();

        public QiwiCheckHistory()
        {
            MyCokies = new CookieDictionary();
            def.Cookies = MyCokies;
            def.AllowAutoRedirect = !true;
            def.UserAgent = UA;

            def.IgnoreProtocolErrors = true;
        }

        #region DeSerialise
        class Entity
        {
            public string ticket { get; set; }
        }

        class AuthJson
        {
            public Entity entity { get; set; }
        }
        #endregion

        #region trash
        public class Sum
        {
            public double amount { get; set; }
            public int currency { get; set; }
        }

        public class Commission
        {
            public double amount { get; set; }
            public int currency { get; set; }
        }

        public class Total
        {
            public double amount { get; set; }
            public int currency { get; set; }
        }

        public class Provider
        {
            public int id { get; set; }
            public string shortName { get; set; }
            public string longName { get; set; }
            public string logoUrl { get; set; }
            public string description { get; set; }
            public string keys { get; set; }
            public string siteUrl { get; set; }
            public List<object> extras { get; set; }
        }

        public class Source
        {
            public int id { get; set; }
            public string shortName { get; set; }
            public string longName { get; set; }
            public object logoUrl { get; set; }
            public object description { get; set; }
            public string keys { get; set; }
            public object siteUrl { get; set; }
            public List<object> extras { get; set; }
        }

        public class Features
        {
            public bool chequeReady { get; set; }
            public bool bankDocumentReady { get; set; }
            public bool regularPaymentEnabled { get; set; }
            public bool bankDocumentAvailable { get; set; }
            public bool repeatPaymentEnabled { get; set; }
            public bool favoritePaymentEnabled { get; set; }
            public bool greetingCardAttached { get; set; }
        }

        public class ServiceExtras
        {
        }

        public class View
        {
            public string title { get; set; }
            public string account { get; set; }
        }

        public class Datum
        {
            public long txnId { get; set; }
            public object personId { get; set; }
            public DateTime date { get; set; }
            public int errorCode { get; set; }
            public object error { get; set; }
            public string status { get; set; }
            public string type { get; set; }
            public string statusText { get; set; }
            public string trmTxnId { get; set; }
            public string account { get; set; }
            public Sum sum { get; set; }
            public Commission commission { get; set; }
            public Total total { get; set; }
            public Provider provider { get; set; }
            public Source source { get; set; }
            public string comment { get; set; }
            public double currencyRate { get; set; }
            public List<object> paymentExtras { get; set; }
            public Features features { get; set; }
            public ServiceExtras serviceExtras { get; set; }
            public View view { get; set; }
        }
        #endregion

        public class History
        {
            public List<Datum> data { get; set; }
            //public long nextTxnId { get; set; }
            //public DateTime nextTxnDate { get; set; }
        }

        public bool auth(string login, string pass)
        {
            bool check = false;
            using (var request = def)
            {
                HttpResponse resp = null;
                string tresp = string.Empty;
                request.Get("https://qiwi.com/");

                var pdata = ("{'login':'" + login + "','password':'" + pass + "','captcha':''}").Replace('\'', '"');
                request.Referer = "https://qiwi.com/";
                request.AddHeader("Accept", "application/vnd.qiwi.sso-v1+json");

                resp = request.Post("https://sso.qiwi.com/cas/tgts", pdata, "application/json");
                tresp = resp.ToString();

                if (tresp.Contains(@"error"":{""message"))
                    check = false;
                else if (tresp.Contains(@"""ticket"":""TGT"))
                {
                    pdata = Regex.Match(tresp, @"ticket.{3}([^""]+)").Groups[1].Value;

                    pdata = ("{'ticket':'" + pdata + "','service':'https://qiwi.com/j_spring_cas_security_check'}").Replace('\'', '"');
                    request.Referer = "https://sso.qiwi.com/app/proxy?v=1";
                    resp = request.Post("https://sso.qiwi.com/cas/sts", pdata, "application/json");
                    tresp = resp.ToString();
                    pdata = Regex.Match(tresp, @"ticket.{3}([^""]+)").Groups[1].Value;
                    resp = request.Get("https://qiwi.com/j_spring_cas_security_check?ticket=" + pdata);

                    check = true;
                }

                request.AddHeader("Accept", "application/vnd.qiwi.sso-v1+json");
                var json = $"{{\"login\":\"{login}\",\"password\":\"{pass}\",\"captcha\":\"\"}}";
                json = request.Post("https://sso.qiwi.com/cas/tgts", json, "application/json").ToString();
                var tokens = JsonConvert.DeserializeObject<AuthJson>(json);


                request.AddHeader("Accept", "application/vnd.qiwi.sso-v1+json");
                json = $"{{\"ticket\":\"{tokens.entity.ticket}\",\"service\":\"https://qiwi.com/j_spring_cas_security_check\"}}";
                json = request.Post("https://sso.qiwi.com/cas/sts", json, "application/json").ToString();
                tokens = JsonConvert.DeserializeObject<AuthJson>(json);


                request.AddHeader("Accept", "application/json");
                request.AddParam("grant_type", "sso_service_ticket");
                request.AddParam("client_id", "sso.qiwi.com");
                request.AddParam("client_software", "WEB v4.25.0");
                request.AddParam("service_name", "https://qiwi.com/j_spring_cas_security_check");
                request.AddParam("ticket", tokens.entity.ticket);

                json = request.Post("https://qiwi.com/oauth/token").ToString();

                string TokenHeadV2 = "sso.qiwi.com:" + Regex.Match(json, @"access_token\W{3}(\w+)").Groups[1].Value;
                TokenHeadV2 = Convert.ToBase64String(Encoding.UTF8.GetBytes(TokenHeadV2));

                request.AddHeader("Accept", "application/json");
                request.AddHeader("Authorization", $"TokenHeadV2 {TokenHeadV2}");
                request.Referer = "https://qiwi.com/history";
                request.AddHeader("Client-Software", "WEB v4.25.0");
                json = request.Get($"https://edge.qiwi.com/payment-history/v2/persons/{login}/payments?rows=50").ToString();

                var vvv = JsonConvert.DeserializeObject<History>(json).data;


                var werwer = 1;
            }
            return check;
        }

        public void CheckPaymentsHistory(string login, string pass)
        {
            using (var request = def)
            {
                HttpResponse resp = null;
                string tresp = string.Empty;
                request.Get("https://qiwi.com/");

                var pdata = ("{'login':'+" + login + "','password':'" + pass + "','captcha':''}").Replace('\'', '"');
                request.Referer = "https://qiwi.com/";
                request.AddHeader("Accept", "application/vnd.qiwi.sso-v1+json");

                resp = request.Post("https://sso.qiwi.com/cas/tgts", pdata, "application/json");
                tresp = resp.ToString();

                request.AddHeader("Accept", "application/vnd.qiwi.sso-v1+json");
                var json = $"{{\"login\":\"{login}\",\"password\":\"{pass}\",\"captcha\":\"\"}}";
                json = request.Post("https://sso.qiwi.com/cas/tgts", json, "application/json").ToString();
                var tokens = JsonConvert.DeserializeObject<AuthJson>(json);

                request.AddHeader("Accept", "application/vnd.qiwi.sso-v1+json");
                json = $"{{\"ticket\":\"{tokens.entity.ticket}\",\"service\":\"https://qiwi.com/j_spring_cas_security_check\"}}";
                json = request.Post("https://sso.qiwi.com/cas/sts", json, "application/json").ToString();
                tokens = JsonConvert.DeserializeObject<AuthJson>(json);

                request.AddHeader("Accept", "application/json");
                request.AddParam("grant_type", "sso_service_ticket");
                request.AddParam("client_id", "sso.qiwi.com");
                request.AddParam("client_software", "WEB v4.25.0");
                request.AddParam("service_name", "https://qiwi.com/j_spring_cas_security_check");
                request.AddParam("ticket", tokens.entity.ticket);

                json = request.Post("https://qiwi.com/oauth/token").ToString();

                string TokenHeadV2 = "sso.qiwi.com:" + Regex.Match(json, @"access_token\W{3}(\w+)").Groups[1].Value;
                TokenHeadV2 = Convert.ToBase64String(Encoding.UTF8.GetBytes(TokenHeadV2));

                request.AddHeader("Accept", "application/json");
                request.AddHeader("Authorization", $"TokenHeadV2 {TokenHeadV2}");
                request.Referer = "https://qiwi.com/history";
                request.AddHeader("Client-Software", "WEB v4.25.0");
                json = request.Get($"https://edge.qiwi.com/payment-history/v2/persons/{login}/payments?rows=50").ToString();

                try
                {
                    var list = JsonConvert.DeserializeObject<History>(json).data;

                    list = list.OrderBy(x => x.date).ToList();

                    foreach (var item in list)
                    {
                        if (item.comment != null && item.comment.StartsWith("id"))
                        {
                            int publicId;

                            if (Int32.TryParse(item.comment.Substring(2), out publicId))
                            {
                                CheckQiwiPayment checkQiwiPayment = new CheckQiwiPayment
                                {
                                    UserPublicId = publicId,
                                    Amount = item.sum.amount,
                                    Date = item.date,
                                    AcceptedAccount = login,
                                    SendAccount = item.account
                                };

                                if (item.sum.currency == 643)
                                {
                                    QiwiHelper.AddQiwiPayment(checkQiwiPayment);
                                }
                            }
                        }
                    }

                    //DataHelper.QiwiHistoryChecked(login);
                }
                catch (System.Exception ex)
                {
                    //

                    DataHelper.AddException(ex);
                }
            }

            var q = new QiwiAggregator.Model.QiwiObject();
            q.CheckQiwiAccountBalance(login, pass);
        }

        static string DateTimeToUnixTimestamp(DateTime dateTime)
        {
            TimeSpan span = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc));
            return (span.TotalMilliseconds).ToString("0");
        }
    }
}