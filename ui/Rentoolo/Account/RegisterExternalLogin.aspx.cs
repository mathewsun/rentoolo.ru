using System;
using System.Linq;
using System.Web;
using System.Web.Security;
using DotNetOpenAuth.AspNet;
using DotNetOpenAuth.GoogleOAuth2;
using Microsoft.AspNet.Membership.OpenAuth;
using Rentoolo.Model;
using System.Collections.Generic;
using System.Web.UI;
namespace Rentoolo.Account
{
    public partial class RegisterExternalLogin : Page
    {
        protected string ProviderName
        {
            get { return (string)ViewState["ProviderName"] ?? String.Empty; }
            private set { ViewState["ProviderName"] = value; }
        }

        protected string ProviderDisplayName
        {
            get { return (string)ViewState["ProviderDisplayName"] ?? String.Empty; }
            private set { ViewState["ProviderDisplayName"] = value; }
        }

        protected string ProviderUserId
        {
            get { return (string)ViewState["ProviderUserId"] ?? String.Empty; }
            private set { ViewState["ProviderUserId"] = value; }
        }

        protected string ProviderUserName
        {
            get { return (string)ViewState["ProviderUserName"] ?? String.Empty; }
            private set { ViewState["ProviderUserName"] = value; }
        }

        protected string ProviderUserEmail
        {
            get { return (string)ViewState["ProviderUserEmail"] ?? String.Empty; }
            private set { ViewState["ProviderUserEmail"] = value; }
        }

        protected void Page_Load()
        {

            if (!IsPostBack)
            {
                ProcessProviderResult();
            }
        }

        private void ProcessProviderResult()
        {

            AuthenticationResult authResult = VerifyAuthentication("~/Account/RegisterExternalLogin.aspx");

            bool hasEmail = authResult.ExtraData.TryGetValue("email", out string email);
            ProviderUserEmail = email;

            if (String.IsNullOrEmpty(ProviderName))
            {
                Response.Redirect(FormsAuthentication.LoginUrl);
            }

            if (!authResult.IsSuccessful)
            {
                Title = "External login failed";
                ModelState.AddModelError("Provider", String.Format("External login {0} failed.", ProviderDisplayName));

                // To view this error, enable page tracing in web.config (<system.web><trace enabled="true"/></system.web>) and visit ~/Trace.axd
                Trace.Warn("OpenAuth", String.Format("There was an error verifying authentication with {0})", ProviderDisplayName), authResult.Error);
                return;
            }

            CreateUserAndLogin(hasEmail);

        }

        private void Login()
        {
            using (var ctx = new RentooloEntities())
            {
                UsersOpenAuthAccounts userOpenAuthAccounts = ctx.UsersOpenAuthAccounts.Where(c => c.ProviderName == ProviderName
                && c.ProviderUserId == ProviderUserId).FirstOrDefault();
                if (userOpenAuthAccounts != null)
                {
                    FormsAuthentication.SetAuthCookie(userOpenAuthAccounts.MembershipUserName, createPersistentCookie: false);
                    RedirectToReturnUrl();
                }
                else
                {
                    return;
                }
            }
        }

        private void RedirectToReturnUrl()
        {
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);

            if (string.IsNullOrEmpty(returnUrl))
            {
                Response.Redirect("~/Account/Cabinet");
            }
            else
            {
                Response.Redirect(string.Format("~/{0}", returnUrl.Replace("%2f", "/")));
            }
        }

        private AuthenticationResult VerifyAuthentication(string redirectUrl)
        {
            try
            {
                GoogleOAuth2Client.RewriteRequest();
                AuthenticationResult _authResult = OpenAuth.VerifyAuthentication(redirectUrl);

                ProviderName = OpenAuth.GetProviderNameFromCurrentRequest();
                ProviderDisplayName = OpenAuth.GetProviderDisplayName(ProviderName);
                ProviderUserId = _authResult.ProviderUserId;
                ProviderUserName = _authResult.UserName;

                return _authResult;
            }
            catch (ArgumentException ex)
            {
                Response.Redirect("~/Account/Login.aspx");
                return null;
            }
        }

        private void CreateUserAndLogin(bool hasEmail)
        {
            MembershipUser membershipUser;
            Users user;

            Login();

            var MembershipsUserName = ProviderUserName + Membership.GeneratePassword(20, 0);
            // тут добавил пару символов, потому что, то что прилетает это имя и фамиля,
            // думаю они будут часто повторяться
            // либо как то убрать уникальность с никнеймов

            if (hasEmail)
            {
                membershipUser = Membership.CreateUser(MembershipsUserName, Membership.GeneratePassword(8, 1)
                                , ProviderUserEmail);
            }
            else
            {
                membershipUser = Membership.CreateUser(MembershipsUserName, Membership.GeneratePassword(8, 1));
            }

            user = DataHelper.GetUser((Guid)membershipUser.ProviderUserKey);

            user.PublicId = DataHelper.GenerateUserPublicId();
            DataHelper.UpdateUser(user);

            AddAccountToExistingUser(Membership.ApplicationName, membershipUser.UserName);

            Login();
        }

        private void AddAccountToExistingUser(string AplicationName, string MembershipUserName)
        {
            using (var ctx = new RentooloEntities())
            {
                UsersOpenAuthAccounts userOpenAuthAccounts = new UsersOpenAuthAccounts();

                userOpenAuthAccounts.ApplicationName = AplicationName;
                userOpenAuthAccounts.ProviderName = ProviderName;
                userOpenAuthAccounts.ProviderUserId = ProviderUserId;
                userOpenAuthAccounts.ProviderUserName = ProviderUserName;
                userOpenAuthAccounts.MembershipUserName = MembershipUserName;

                UsersOpenAuthData usersOpenAuthData = new UsersOpenAuthData();

                usersOpenAuthData.ApplicationName = AplicationName;
                usersOpenAuthData.MembershipUserName = MembershipUserName;
                usersOpenAuthData.HasLocalPassword = true;


                userOpenAuthAccounts.UsersOpenAuthData = usersOpenAuthData;
                usersOpenAuthData.UsersOpenAuthAccounts.Add(userOpenAuthAccounts);

                ctx.UsersOpenAuthAccounts.Add(userOpenAuthAccounts);
                ctx.UsersOpenAuthData.Add(usersOpenAuthData);
                try
                {
                    ctx.SaveChanges();
                }
                catch
                {
                    ModelState.AddModelError("Provider", String.Format("Аккаунт уже создан и привязан к другой учётной записи."));
                    Trace.Warn("OpenAuth", String.Format("Аккаунт уже создан и привязан к другой учётной записи)"));

                    return;
                }
            }
        }
    }
}