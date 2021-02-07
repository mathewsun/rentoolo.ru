using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using HttpGetAttribute = System.Web.Mvc.HttpGetAttribute;

namespace Rentoolo.Controllers.MVC
{
    public class ChatsController : Controller
    {
        //todo
        // add this static helper method to datahelper 
        JObject GetJsonBody(HttpRequestBase req)
        {
            string txt;
            using (StreamReader reader = new StreamReader(req.InputStream))
            {
                txt = reader.ReadToEnd();
            }
            return new JObject(txt);
        }


        //TODO: add logic to add users using ChatInviteTokens


        [HttpGet] // id - chat id
        public string AddUsersInChat(long id)
        {

            JObject json = GetJsonBody(Request);
            JArray userIds = new JArray(json["userIds"]);

            

            List<ChatUsers> chatUsers = new List<ChatUsers>();

            foreach(var userId in userIds)
            {
                chatUsers.Add(new ChatUsers() { ChatId = id, UserId = Guid.Parse((string)userId) });
            }

            //string 
            

            
            return "ok";
        }


        // TODO: test this
        [System.Web.Mvc.HttpPost]
        public string CreateChat([FromBody]Chats chatInfo)
        {
            var r = Request;

            long chatId = DataHelper.CreateChat(chatInfo);


            AddUsersInChat(chatId);



            return "ok";
        }





        // GET: Chats
        public ActionResult Index()
        {
            return View();
        }
    }
}