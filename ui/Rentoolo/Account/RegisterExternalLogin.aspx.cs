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

        protected void logIn_Click(object sender, EventArgs e)
        {
            CreateUser();
        }

        protected void cancel_Click(object sender, EventArgs e)
        {
            RedirectToReturnUrl();
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
                userNameForm.Visible = false;

                ModelState.AddModelError("Provider", String.Format("External login {0} failed.", ProviderDisplayName));

                // To view this error, enable page tracing in web.config (<system.web><trace enabled="true"/></system.web>) and visit ~/Trace.axd
                Trace.Warn("OpenAuth", String.Format("There was an error verifying authentication with {0})", ProviderDisplayName), authResult.Error);
                return;
            }

            //краш
            //if (OpenAuth.Login(authResult.Provider, authResult.ProviderUserId, createPersistentCookie: false))
            //{
            //    RedirectToReturnUrl();
            //}

            Login();

            userName.Text = authResult.UserName;
            if (hasEmail)
            {
                Email.Enabled = false;
                Email.Text = ProviderUserEmail;
            }
            else
            {
                Email.Enabled = true;
            }

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
                    Response.Redirect("~/Account/Cabinet.aspx");
                }
                else
                {
                    return;
                }
            }
        }

        private void RedirectToReturnUrl()
        {
            var returnUrl = Request.QueryString["ReturnUrl"];
            if (!String.IsNullOrEmpty(returnUrl) && OpenAuth.IsLocalUrl(returnUrl))
            {
                Response.Redirect(returnUrl);
            }
            else
            {
                Response.Redirect("~/");
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

        private void CreateUser()
        {
            // проверить входные данные

            // создаёт пользователя или добавлет пользователю возможность входа через соц сети
            MembershipUser membershipUser;
            Users user;
            if (Membership.GetUser(userName.Text) == null)
            {
                membershipUser = Membership.CreateUser(userName.Text, Password.Text, ProviderUserEmail);
                user = DataHelper.GetUser((Guid)membershipUser.ProviderUserKey);

                user.Pwd = Password.Text;// pwd это пароль??
                user.PublicId = DataHelper.GenerateUserPublicId();
                DataHelper.UpdateUser(user);
            }
            else
            {
                membershipUser = Membership.GetUser();
                if (membershipUser == null)
                {
                    ModelState.AddModelError("Provider", String.Format("Этот логин занят", ProviderDisplayName));
                    return;
                }
            }

            AddAccountToExistingUser(Membership.ApplicationName, membershipUser.UserName);
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
                    Login();
                }
                catch
                {
                    ModelState.AddModelError("Provider", String.Format("Аккаунт уже создан и привязан к другой учётной записи."));
                    Trace.Warn("OpenAuth", String.Format("Аккаунт уже создан и привязан к другой учётной записи)"));
                    userNameForm.Visible = false;
                    return;
                }
            }

            //поидее должно так работать))
            // но хз чё там происходит и выдаёт странную ошибку)
            //OpenAuth.UsersAccountsTableName = "UsersOpenAuthAccounts";
            //OpenAuth.UsersDataTableName = "UsersOpenAuthData";
            //OpenAuth.AddAccountToExistingUser(ProviderName, ProviderUserId, ProviderUserName, user.UserName);
            //OpenAuth.AddLocalPassword(user.UserName, Password.Text);
        }

    }
}