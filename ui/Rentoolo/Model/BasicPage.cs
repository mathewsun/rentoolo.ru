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
                    return user;

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

            Session["User"] = user;
        }
    }
}