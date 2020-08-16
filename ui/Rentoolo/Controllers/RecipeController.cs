using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Rentoolo.Model;

namespace Rentoolo.Controllers
{
    public class RecipeController : ApiController
    {
        public IHttpActionResult Get(int id)
        {
            Recipes recipe = KitchenDataHelper.GetRecipe(id);

            return Json(recipe);
        }
    }
}
