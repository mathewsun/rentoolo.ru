using System;
using System.Web;
using System.Web.UI;
using System.Net;
using System.Collections.Specialized;
using System.IO;
using System.Web.Script.Serialization;

namespace Rentoolo.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
            if (!Validate())
            {
                e.Cancel = true;
            }
        }

        protected void Unnamed1_LoggedIn(object sender, EventArgs e)
        {
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);

            if (string.IsNullOrEmpty(returnUrl))
            {
                Response.Redirect("~/Account/Cabinet.aspx");
            }
            else
            {
                Response.Redirect(string.Format("~/{0}", returnUrl.Replace("%2f", "/")));
            }

        }
    }
}