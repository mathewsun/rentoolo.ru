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
    public class LikesDislikesController : ApiController
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
        public void Post([FromBody] string value)
        {
        }

        public class LikeDislikeCmd
        {
            public string Cmd { get; set; }
            public int CommentId { get; set; }
        }

        // PUT api/<controller>/5
        public void Put([FromBody] LikeDislikeCmd value)
        {
            Users user = (Users)HttpContext.Current.Session["User"];

            switch (value.Cmd)
            {
                case "Like":
                    DataHelper.LikeUnLike(user.UserId, value.CommentId);
                    break;
                case "DisLike":
                    DataHelper.DisLikeUnDisLike(user.UserId, value.CommentId);
                    break;
                default:
                    throw new Exception("unsopprted case");
                    break;

            }
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}