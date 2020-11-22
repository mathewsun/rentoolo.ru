using System;
using System.Web;
using System.Web.UI;
using System.Net;
using System.Collections.Specialized;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Security;
using Rentoolo.Model;
using System.Text.RegularExpressions;

namespace Rentoolo.Account
{
    public partial class Login : BasicPage
    {
        //public bool IsLocalhost { get; set;}


        protected void Page_Load(object sender, EventArgs e)
        {
            //string host = HttpContext.Current.Request.Url.Host;

            //if (host == "localhost2")
            //{
            //    IsLocalhost = true;
            //}
            //else
            //{
            //    IsLocalhost = false;
            //}

            //RegisterHyperLink.NavigateUrl = "~/Account/Cabinet.aspx";

            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);

            //if (String.IsNullOrEmpty(returnUrl))
            //{
            //    RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
            //}
        }

        public class MyObject
        {
            public string success { get; set; }
        }

        public bool Validate()
        {
            string Response = Request["g-recaptcha-response"];//Getting Response String Append to Post Method
            bool Valid = false;
            //Request to Google Server
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create
            (" https://www.google.com/recaptcha/api/siteverify?secret=6Lf4W6QUAAAAALoKNTfOJAVeAhXRCaVfUiQ5fmRr&response=" + Response);
            try
            {
                //Google recaptcha Response
                using (WebResponse wResponse = req.GetResponse())
                {

                    using (StreamReader readStream = new StreamReader(wResponse.GetResponseStream()))
                    {
                        string jsonResponse = readStream.ReadToEnd();

                        JavaScriptSerializer js = new JavaScriptSerializer();
                        MyObject data = js.Deserialize<MyObject>(jsonResponse);// Deserialize Json

                        Valid = Convert.ToBoolean(data.success);
                    }
                }

                return Valid;
            }
            catch (WebException ex)
            {
                throw ex;
            }
        }

        protected void On_LoggingIn(object sender, System.Web.UI.WebControls.LoginCancelEventArgs e)
        {
            //if (IsLocalhost)
            //{
            //    e.Cancel = false;
            //    return;
            //}


            if (!Validate())
            {
                e.Cancel = true;
            }
        }

        protected void Redirect()
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

        protected void Authenticate(object sender, System.Web.UI.WebControls.AuthenticateEventArgs e)
        {
            string login;
            if (IsValidEmail(Login1.UserName))
            {
                var membershipUser = DataHelper.GetUserMembershipByEmail(Login1.UserName);
                if (membershipUser == null)
                {
                    e.Authenticated = false;
                    return;
                }
                login = DataHelper.GetUser(membershipUser.UserId).UserName;
                if (string.IsNullOrEmpty(login))
                {
                    e.Authenticated = false;
                    return;
                }
            }
            else
            {
                login = Login1.UserName;
            }

            if (Membership.ValidateUser(login, Login1.Password))
            {

                e.Authenticated = true;
                FormsAuthentication.SetAuthCookie(login, createPersistentCookie: false);
                Redirect();
            }
            else
            {
                e.Authenticated = false;
            }
        }
        bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }
    }
}