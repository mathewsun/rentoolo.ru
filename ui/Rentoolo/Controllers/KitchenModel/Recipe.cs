using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Controllers.KitchenModel
{
    public class Recipe
    {
        public string Name { get; set; }

        public string ImgUrl { get; set; }

        public int TimeMinutesToCook { get; set; }

        public int CountLikes { get; set; }
    }
}