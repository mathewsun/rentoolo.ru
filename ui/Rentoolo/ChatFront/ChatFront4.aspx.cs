using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.ChatFront
{
    public partial class ChatFront4 : BasicPage
    {
        public Users CurUser;
        public string StartChatId = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            StartChatId = Request.QueryString["chatId"] != null &&
                Request.QueryString["chatId"] != "" ? Request.QueryString["chatId"] : "";

            //DataHelper.CreateChatDialogIfNotExist

            CurUser = User;
        }
    }
}