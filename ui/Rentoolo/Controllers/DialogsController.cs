using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    
    public class DialogsController : ApiController
    {

        // GET api/<controller>/
        //[Route(Name = "DefaultApi")]
        //[HttpGet]
        //public IHttpActionResult Get([FromUri(Name ="userId")]string userId)
        //{
        //    return Json(DataHelper.GetDialogs(Guid.Parse(userId)));
        //}

        // GET api/<controller>/Id
        [Route(Name = "ChatsApi")]
        [HttpGet]
        public IHttpActionResult DialogList(string id)
        {
            return Json(DataHelper.GetDialogs(Guid.Parse(id)));
        }


        [Route(Name = "ChatsApi")]
        [HttpGet]
        public IHttpActionResult Messages(int id)
        {
            var res = DataHelper.GetMessages(id);
            return Json(res);
        }


        [Route(Name = "ChatsApi")]
        [HttpPost]
        public void CreateMessage(DialogMessages msg)
        {
            DataHelper.SaveNewMessage(msg);
            
        }





        // GET api/<controller>
        //public IEnumerable<string> Get()
        //{
        //    return new string[] { "value1", "value2" };
        //}


        // POST api/<controller>
        public void Post([FromBody]string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}