using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class AdvertsDataHelper
    {
        #region Объявления

        public static List<Adverts> GetAdverts()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Adverts.OrderByDescending(x => x.Created).ToList();

                return list;
            }
        }

        public static Adverts GetAdvert(long id)
        {
            using (var dc = new RentooloEntities())
            {
                Adverts item = dc.Adverts.FirstOrDefault(x => x.Id == id);

                return item;
            }
        }

        #endregion
    }
}