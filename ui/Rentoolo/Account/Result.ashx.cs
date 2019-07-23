using System;
using System.Web;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    /// <summary>
    /// Сводное описание для Result
    /// </summary>
    public class Result : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string eventName = string.Empty;
            string result = string.Empty;
            string id = string.Empty;
            string comment = string.Empty;

            eventName = context.Request["eventName"];
            result = context.Request["result"];
            id = context.Request["id"];
            comment = context.Request["comment"];

            if (eventName == "saveUserParam")
            {
                if (id == "Referrer")
                {
                    Model.Users referal = DataHelper.GetUserByName(context.User.Identity.Name);

                    int publicId;

                    if (!int.TryParse(result, out publicId)) return;

                    Model.Users referer = DataHelper.GetUserByPublicId(publicId);

                    if (referer == null) return;

                    //сделать проверку что не является рефералом реферера и на уровень выше тоже

                    if(referer.UserId == referal.UserId) return;

                    Model.Referrals upperReferal = DataHelper.GetReferral(referer.UserId);

                    if (upperReferal != null && upperReferal.ReferrerUserId == referal.UserId) return;

                    if (upperReferal != null)
                    {
                        Model.Referrals upper2Referal = DataHelper.GetReferral(upperReferal.ReferrerUserId);

                        if (upper2Referal != null && upper2Referal.ReferrerUserId == referal.UserId) return;
                    }

                    Model.Referrals referralItem = new Model.Referrals
                    {
                        ReferralUserId = referal.UserId,
                        ReferrerUserId = referer.UserId,
                        WhenDate = DateTime.Now
                    };

                    DataHelper.AddReferral(referralItem);
                }

                if (id == "Email")
                {
                    DataHelper.UpdateUserEmail(context.User.Identity.Name, result);
                }
                else
                {
                    DataHelper.UpdateUserParametr(context.User.Identity.Name, id, result);
                }
            }

            context.Response.ContentType = "text/plain";
            context.Response.Write("Ok");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}