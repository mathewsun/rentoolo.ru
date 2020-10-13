using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class UserProfile : BasicPage
    {
        // не менять имя, при изменении имени на User будет конфликт имен при наследовании
        public Users CurUser;
        

        protected void Page_Load(object sender, EventArgs e)
        {
            CurUser = DataHelper.GetUser(Guid.Parse(Request.QueryString["id"]));
            if (!IsPostBack)
            {
                
                
            }
        }

        // join to chat
        protected void Button1_Click(object sender, EventArgs e)
        {
            DataHelper.CreateChatDialog(new Chats() {
                OwnerId = User.UserId, ChatType = 1, ChatName = CurUser.UserName
            }, CurUser.UserId);
        }
    }
}