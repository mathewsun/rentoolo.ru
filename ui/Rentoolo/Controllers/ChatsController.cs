using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class ChatsController : ApiController
    {

        // url types
        // chats?anotheruser=           - for chat
        // chats?anotheruser=GuidValue  - for dialog


        // class Chats field type - 0 for chats, 1 - for dialogs


        public void PostChat([FromBody]Chats chatInfo,[FromUri]string anotherUser)
        {
            if (anotherUser == null)
            {
                DataHelper.CreateChat(chatInfo);
            }
            else
            {
                DataHelper.CreateChatDialog(chatInfo, Guid.Parse(anotherUser));
            }
        }

        
        public IHttpActionResult GetChatList(string id)
        {
            return Json(DataHelper.GetChatsForUser(Guid.Parse(id)));
        }


        




        public void PutChatUser(ChatUsers chatUser)
        {
            DataHelper.AddChatUser(chatUser);
        }


        
    }
}
