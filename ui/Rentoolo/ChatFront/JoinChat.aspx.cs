using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.ChatFront
{
    public partial class JoinChat : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string token = Request.QueryString["token"];

            


        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];
            Guid gtoken = Guid.Parse(token);

            ChatInviteTokens tokenInfo = DataHelper.GetChatTokenInfo(gtoken);

            Model.Chats chat = DataHelper.GetChatByToken(gtoken);

            if(tokenInfo.Status == 0)
            {
                DataHelper.AddChatUser(new ChatUsers()
                {
                    ChatId = chat.Id,
                    UserId = User.UserId
                });
            }


            Response.Redirect("/ChatFront/ChatFront4.aspx?chatId="+chat.Id);

        }
    }
}