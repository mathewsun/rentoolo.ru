using System;
using System.Web.Security;
using System.Web.UI;

namespace Rentoolo.Model
{
    public class BasicPage : Page
    {
        public Users User
        {
            get
            {
                Users user = (Users)Session["User"];

                if (user != null)
                {
                    AddUserLoginStat(user.UserId);

                    return user;
                }

                MembershipUser membershipUser = System.Web.Security.Membership.GetUser();

                if (membershipUser == null
                    || membershipUser.ProviderUserKey == null)
                {
                    return null;
                }

                if (!membershipUser.IsApproved)
                    FormsAuthentication.SignOut();

                user = DataHelper.GetUser(new Guid(membershipUser.ProviderUserKey.ToString()));

                Session["User"] = user;

                return user;
            }
        }

        protected void UpdateSession()
        {
            MembershipUser membershipUser = System.Web.Security.Membership.GetUser();

            if (membershipUser == null
                || membershipUser.ProviderUserKey == null)
            {
                return;
            }

            if (!membershipUser.IsApproved)
                FormsAuthentication.SignOut();

            Users user = DataHelper.GetUser(new Guid(membershipUser.ProviderUserKey.ToString()));

            if (Session["User"] == null)
            {
                AddUserLoginStat(user.UserId);
            }

            Session["User"] = user;
        }

        public void AddUserLoginStat(Guid userId)
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    DataHelper.AddLoginStat(userId, addresses[0]);
                }
            }
            else
            {
                DataHelper.AddLoginStat(userId, "localhost");
            }
        }
    }
}