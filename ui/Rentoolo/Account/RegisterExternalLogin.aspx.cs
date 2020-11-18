using System;
using System.Linq;
using System.Web;
using System.Web.Security;
using DotNetOpenAuth.AspNet;
using DotNetOpenAuth.GoogleOAuth2;
using DotNetOpenAuth;
using Microsoft.AspNet.Membership.OpenAuth;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class RegisterExternalLogin : System.Web.UI.Page
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

        protected void Page_Load(System.Web.UI.WebControls.LoginCancelEventArgs e)
        {
            if (!IsPostBack)
            {
                ProcessProviderResult(e);
            }
        }

        protected void logIn_Click(object sender, EventArgs e)
        {
            CreateAndLoginUser();
        }

        protected void cancel_Click(object sender, EventArgs e)
        {
            RedirectToReturnUrl();
        }

        private void ProcessProviderResult(System.Web.UI.WebControls.LoginCancelEventArgs e)
        {
            string redirectUrl = "~/Account/RegisterExternalLogin.aspx";
            var authResult = VerifyAuthentication(redirectUrl);

            if (String.IsNullOrEmpty(ProviderName))
            {
                Response.Redirect(FormsAuthentication.LoginUrl);
            }

            // Build the redirect url for OpenAuth verification
            var returnUrl = Request.QueryString["ReturnUrl"];
            if (!String.IsNullOrEmpty(returnUrl))
            {
                redirectUrl += "?ReturnUrl=" + HttpUtility.UrlEncode(returnUrl);
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


            // User has logged in with provider successfully
            // Check if user is already registered locally
            //не пашет
            //if (OpenAuth.Login(authResult.Provider, authResult.ProviderUserId, createPersistentCookie: false))
            //{
            //    RedirectToReturnUrl();
            //}

            using (var ctx = new RentooloEntities())
            {
                var users = ctx.UsersOpenAuthAccounts.Where(x => x.ProviderName == authResult.Provider
                && x.ProviderUserId == authResult.ProviderUserId).ToList();
                if (users.Count > 0)
                {
                    //впустить
                    RedirectToReturnUrl();
                }
            }

            // Strip the query string from action
            Form.Action = ResolveUrl(redirectUrl);

            if (User.Identity.IsAuthenticated)
            {
                // User is already authenticated, add the external login and redirect to return url
                OpenAuth.AddAccountToExistingUser(ProviderName, ProviderUserId, ProviderUserName, User.Identity.Name);
                RedirectToReturnUrl();
            }
            else
            {
                // User is new, ask for their desired membership name
                userName.Text = authResult.UserName;
            }
        }

        private void CreateAndLoginUser()
        {
            if (!IsValid)
            {
                return;
            }

            VerifyAuthentication("~/Account/RegisterExternalLogin.aspx");
            // создаётся запись в users потом краш
            var createResult = OpenAuth.CreateUser(ProviderName, ProviderUserId, ProviderUserName, userName.Text);
            if (!createResult.IsSuccessful)
            {

                ModelState.AddModelError("UserName", createResult.ErrorMessage);

            }
            else
            {
                // User created & associated OK
                if (OpenAuth.Login(ProviderName, ProviderUserId, createPersistentCookie: false))
                {
                    RedirectToReturnUrl();
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
            GoogleOAuth2Client.RewriteRequest();
            AuthenticationResult authResult = OpenAuth.VerifyAuthentication(redirectUrl);

            ProviderName = OpenAuth.GetProviderNameFromCurrentRequest();
            ProviderDisplayName = OpenAuth.GetProviderDisplayName(ProviderName);
            ProviderUserId = authResult.ProviderUserId;
            ProviderUserName = authResult.UserName;

            return authResult;
        }
    }
}