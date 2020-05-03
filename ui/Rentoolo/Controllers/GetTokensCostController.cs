using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Rentoolo.Model;

namespace Rentoolo.Controllers
{
    public class GetTokensCostController : ApiController
    {
        public IHttpActionResult GetTokensCost()
        {
            var result = TokensDataHelper.GetTokensCosts();

            return Ok(result);
        }
        
    }
}
