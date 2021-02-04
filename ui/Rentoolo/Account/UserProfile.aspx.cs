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
        public List<Chats> ChatList = new List<Chats>();


        protected void Page_Load(object sender, EventArgs e)
        {

            // allowed urls:
            // /Account/UserProfile.aspx?id=@10
            // /Account/UserProfile.aspx?id=B98B7EBC-4D5E-405B-88D8-087421C50B8E
            // /Account/UserProfile.aspx?nick=@someUsersNickName



            string id = Request.QueryString["id"];
            string nickName = Request.QueryString["nick"];

            if (nickName == null)
            {


                if (id != null)
                {
                    if (id[0] != '@')
                    {
                        CurUser = DataHelper.GetUser(Guid.Parse(id));
                    }
                    else
                    {
                        CurUser = DataHelper.GetUser(id);

                        if (CurUser == null)
                        {

                            id = id.Trim("@".ToCharArray());
                            CurUser = DataHelper.GetUser(Convert.ToInt32(id));
                        }
                    }
                }
                else
                {
                    CurUser = User;
                }

            }
            else
            {
                CurUser = DataHelper.GetUserByNickName(nickName);
            }


            if (CurUser.UserId != User.UserId)
            {
                ChatList = DataHelper.GetChats(User.UserId);
            }


            //RptrComments.DataSource = ChatList;
            //RptrComments.DataBind();

            if (!IsPostBack)
            {


            }
        }

        // Redirect to chat if it exists
        // if not, create it and redirect
        protected void Button1_Click(object sender, EventArgs e)
        {
            //DataHelper.CreateChatDialog(new Chats() {
            //    OwnerId = User.UserId,
            //    ChatType = 1,
            //    ChatName = CurUser.UserName
            //}, CurUser.UserId);

            bool dialogExists = DataHelper.CheckDialogExistance(User.UserId, CurUser.UserId);

            long chatId;

            if (dialogExists)
            {
                chatId = (long)DataHelper.GetDialogId(User.UserId, CurUser.UserId);

            }
            else
            {
                chatId = DataHelper.CreateChatDialog(User.UserId, CurUser.UserId);
            }


            Response.Redirect("/ChatFront/ChatFront4.aspx?chatId=" + chatId.ToString());
        }

        protected void ChatList_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {

        }


        protected void RptrChats_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }

        protected void RptrChats_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string cmdName = e.CommandName.ToString();
            string cmdArg = e.CommandArgument.ToString();



        }

        protected void Button2_Click(object sender, EventArgs e)
        {

        }

        protected void RptrComments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }

        protected void RptrComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string cmdName = e.CommandName.ToString();
            string cmdArg = e.CommandArgument.ToString();
        }

        protected void Button2_Click1(object sender, EventArgs e)
        {
            string chatName = Request.Form["chatName"];
            //Chats chat = ChatList.FirstOrDefault(x => x.ChatName == TextBox1.Text);
            Chats chat = ChatList.FirstOrDefault(x => x.ChatName == chatName);
            DataHelper.AddChatUser(new ChatUsers() { ChatId = chat.Id, UserId = CurUser.UserId });
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            if (CurUser.UserId == User.UserId)
            {
                string name = TextBox2.Text;
                DataHelper.SetUserUniqueId(CurUser.UserId, name);
            }

        }
    }
}