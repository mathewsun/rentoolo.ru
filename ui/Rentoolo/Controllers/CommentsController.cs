using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class CommentsController : ApiController
    {
        // GET api/<controller>/{id}
        public IEnumerable<spGetCommentsForUser_Result> Get(int id)
        {
            List<spGetCommentsForUser_Result> commentList;
            var name = RequestContext.Principal.Identity.Name;
            Users user = DataHelper.GetUser(name);
            if (user != null)
            {
                commentList = DataHelper.spGetCommentsForUser(user.UserId, id);
            }
            else
            {
                commentList = new List<spGetCommentsForUser_Result>();
            }
            

            //return commentList;
            return commentList;
        }

        // GET api/<controller>
        public string Get()
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}