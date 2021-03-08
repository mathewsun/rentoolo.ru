using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    //[Route(Name = "ChatsApi")]
    public class ChatsController : ApiController
    {

        // url types
        // chats?anotheruser=           - for chat
        // chats?anotheruser=GuidValue  - for dialog


        // class Chats field type - 0 for chats, 1 - for dialogs


        public string Test(int id)
        {
            return "test " + id; 
        }


        public void PostChat([FromBody]Chats chatInfo,[FromUri]string anotherUser)
        {
            if (anotherUser == null)
            {
                //DataHelper.CreateChat(chatInfo);
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

        // http://localhost:53222/api/chats/a55a7415-80e3-4dfd-93a1-3ea9d8d88329
        // http://localhost:53225/api/chats/a55a7415-80e3-4dfd-93a1-3ea9d8d88329


        public IHttpActionResult GetChatList()
        {
            return Json("aaaa");
        }


        public void PutChatUser(ChatUsers chatUser)
        {
            DataHelper.AddChatUser(chatUser);
        }


        
    }
}
