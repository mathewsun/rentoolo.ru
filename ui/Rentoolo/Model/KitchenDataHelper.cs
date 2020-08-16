using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class KitchenDataHelper
    {
        public static Recipes GetRecipe(long id)
        {
            using (var dc = new RentooloEntities())
            {
                Recipes recipe = dc.Recipes.FirstOrDefault(x => x.Id == id);

                return recipe;
            }
        }

    }
}