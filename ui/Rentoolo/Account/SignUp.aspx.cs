using System;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Membership.OpenAuth;
using Rentoolo.Model;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;

namespace Rentoolo.Account
{
    public partial class SignUp : System.Web.UI.Page
    {
        private int _refid = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterUser.ContinueDestinationPageUrl = Request.QueryString["ReturnUrl"];

            try
            {
                _refid = Convert.ToInt32(Request.QueryString["refid"]);

                if (_refid == 0)
                {
                    if (Request.Cookies["refid"] != null)
                    { _refid = Convert.ToInt32(Request.Cookies["refid"].Value); }
                }
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            if (System.Web.Security.Membership.GetUser() != null) Response.Redirect("~/");
        }

        protected void RegisterUser_CreatingUser(Object sender, LoginCancelEventArgs e)
        {
            if (!Validate())
            {
                e.Cancel = true;
            }
        }

        protected void RegisterUser_CreatedUser(object sender, EventArgs e)
        {
            FormsAuthentication.SetAuthCookie(RegisterUser.UserName, createPersistentCookie: false);

            string continueUrl = "~/Account/Cabinet.aspx";  //RegisterUser.ContinueDestinationPageUrl;
            //if (!OpenAuth.IsLocalUrl(continueUrl))
            //{
            //    continueUrl = "~/";
            //}

            Users user = DataHelper.GetUserByName(RegisterUser.UserName);

            Control ctl = null;

            ctl = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("Password");
            if (ctl != null)
            {
                try
                {
                    //user.Pwd = ((TextBox)ctl).Text;
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }

            //ctl = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("TextBoxCommunication");
            //if (ctl != null)
            //{
            //    try
            //    {
            //        user.Communication = ((TextBox)ctl).Text;
            //    }
            //    catch (System.Exception ex)
            //    {
            //        DataHelper.AddException(ex);
            //    }
            //}

            //ctl = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("TextBoxVkontakte");
            //if (ctl != null)
            //{
            //    try
            //    {
            //        user.VkontakteId = ((TextBox)ctl).Text;
            //    }
            //    catch (System.Exception ex)
            //    {
            //        DataHelper.AddException(ex);
            //    }
            //}

            //ctl = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("TextBoxIcq");
            //if (ctl != null)
            //{
            //    try
            //    {
            //        user.Icq = ((TextBox)ctl).Text;
            //    }
            //    catch (System.Exception ex)
            //    {
            //        DataHelper.AddException(ex);
            //    }
            //}

            //ctl = RegisterUser.CreateUserStep.ContentTemplateContainer.FindControl("TextBoxSkype");
            //if (ctl != null)
            //{
            //    try
            //    {
            //        user.Skype = ((TextBox)ctl).Text;
            //    }
            //    catch (System.Exception ex)
            //    {
            //        DataHelper.AddException(ex);
            //    }
            //}

            user.PublicId = DataHelper.GenerateUserPublicId();

            //user.Balance = 50;

            DataHelper.UpdateUser(user);


            if (_refid != 0)
            {
                DataHelper.AddReferral(new Rentoolo.Model.Referrals
                {
                    ReferrerUserId = DataHelper.GetUserByRefId(_refid).UserId,
                    ReferralUserId = user.UserId,
                    WhenDate = DateTime.Now
                });
            }

            #region Логирование операции

            {
                Rentoolo.Model.Operations operation = new Rentoolo.Model.Operations
                {
                    UserId = user.UserId,
                    Value = 0,
                    Type = (int)OperationTypesEnum.Registration,
                    Comment = string.Format("Учетная запись создана."),
                    WhenDate = DateTime.Now
                };

                DataHelper.AddOperation(operation);
            }

            #endregion

            Response.Redirect("~/Account/Cabinet.aspx");
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
    }
}