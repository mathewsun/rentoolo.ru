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
            return Json(DataHelper.GetChats(Guid.Parse(id)));
        }


        public void PutChatUser(ChatUsers chatUser)
        {
            DataHelper.AddChatUser(chatUser);
        }


        
    }
}
