using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class LikesDisLikesController : ApiController
    {
        
        [HttpPost]
        public void Post([FromBody]LikesDisLikes likesDisLikes)
        {
            var c = Request.Content;
            var test = likesDisLikes;
            if (likesDisLikes == null)
            {
                throw new Exception();
            }
        }

        public void Get([FromUri]LikesDisLikes likesDisLikes)
        {
            var c = Request.Content;
            var test = likesDisLikes;
            if (likesDisLikes == null)
            {
                throw new Exception();
            }
        }




        //[httppost]
        //public void post([frombody]likesdislikes likesdislikes)
        //{
        //    var c = request.content;
        //    var test = likesdislikes;
        //    if (likesdislikes == null)
        //    {
        //        throw new exception();
        //    }
        //}

        //public void get([fromuri]likesdislikes likesdislikes)
        //{
        //    var c = request.content;
        //    var test = likesdislikes;
        //    if (likesdislikes == null)
        //    {
        //        throw new exception();
        //    }
        //}



    }
}