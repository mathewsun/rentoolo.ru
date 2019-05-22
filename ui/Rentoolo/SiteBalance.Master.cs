using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class SiteBalance : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;
        
        public List<New> ListNews;

        public Users User
        {
            get
            {
                Users user = (Users)Session["User"];

                if (user != null)
                    return user;

                string userName = Context.User.Identity.Name;

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

        public List<fnGetUserWalletsResult> ListUserWallets;

        protected void Page_Init(object sender, EventArgs e)
        {
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;
        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Context.User.Identity.Name))
            {
                try
                {
                    LoginStatistics item = new LoginStatistics();

                    item.UserName = Context.User.Identity.Name;

                    item.WhenLastDate = DateTime.Now;

                    item.Ip = Request.UserHostAddress;

                    item.Client = 0;

                    DataHelper.AddLoginStatistic(item);
                }
                catch { }

                ListUserWallets = WalletsHelper.GetUserWallets(User.UserId);
            }

            ListNews = DataHelper.GetActiveNewsLast5();
        }

        public void UpdateBalance()
        {
            //Balance = DataHelper.GetBalanceWithUpdateByName(Context.User.Identity.Name);
        }

        public void LoginStatus1_LoggedOut(Object sender, System.EventArgs e)
        {
            Session.Remove("User");

            Response.Redirect("/");
        }
    }
}