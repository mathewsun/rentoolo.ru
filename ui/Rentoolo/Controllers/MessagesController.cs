using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class MessagesController : ApiController
    {


        [Route(Name = "ChatsApi")]
        [HttpPost]
        public void CreateMessage(ChatMessages msg)
        {
            DataHelper.SaveChatMessage(msg);
        }


        [Route(Name = "ChatsApi")]
        [HttpGet]
        public IHttpActionResult Messages(int id)
        {
            return Json(DataHelper.GetChatMessages(id));
        }

        
        

        // PUT: api/Messages/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Messages/5
        public void Delete(int id)
        {
        }
    }
}
