using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Rentoolo.Controllers.KitchenModel;

namespace Rentoolo.Controllers
{
    public class KitchenController : ApiController
    {
        public IHttpActionResult GetTop5Recipes()
        {
            List<Recipes> result = new List<Recipes>();

            result.Add(new Recipes
            {
                Name = "Воздушные блины на пахте",
                ImgUrl = "/img/kitchen/vozdushnie-blini-na-pahte.jpg",
                CountLikes = 720,
                TimeMinutesToCook = 15
            });

            return Ok(result);
        }
    }
}
