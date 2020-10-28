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
            
            var coockies = Request.Headers.GetCookies();
            //RequestContext.Principal
            //Users user = (Users)HttpContext.Current.Session["User"];

            //List<spGetCommentsForUser_Result> commentList = DataHelper.spGetCommentsForUser(user.UserId, id);

            //return commentList;
            return null;
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