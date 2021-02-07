using Newtonsoft.Json.Linq;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class ChatManageController : ApiController
    {
        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        // Create chat
        public void Post([FromBody] ChatCreationInfo chatInfo)
        {
            long chatId = DataHelper.CreateChat(new Chats() 
            { OwnerId = chatInfo.OwnerId, 
                ChatName = chatInfo.ChatName, 
                ChatType = 0 
            });

            Put(chatId, chatInfo.UserIds);
        }

        JObject GetJsonBody(Task<Stream> stream)
        {
            string txt;
            using (StreamReader reader = new StreamReader(stream.Result))
            {
                txt = reader.ReadToEnd();
            }
            return new JObject(txt);
        }

        // PUT api/<controller>/5
        // add users in chat
        public void Put(long id, [FromBody] List<Guid> userIds)
        {


            List<ChatUsers> chatUsers = new List<ChatUsers>();

            foreach (var userId in userIds)
            {
                chatUsers.Add(new ChatUsers() { ChatId = id, UserId = userId });
            }


            DataHelper.AddChatUsers(chatUsers);


        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}