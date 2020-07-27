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

        public static long AddAdvert(Adverts item)
        {
            using (var dc = new RentooloEntities())
            {
                var result = dc.Adverts.Add(item);

                var res = dc.SaveChanges();

                return result.Id;
            }
        }

        public static List<Adverts> GetAdvertsForMainPage(SellFilter filter)
        {
            using (var ctx = new RentooloEntities())
            {
                if (!string.IsNullOrEmpty(filter.Search))
                {
                    var list = ctx.Adverts.Where(x => x.Name.Contains(filter.Search) || x.Description.Contains(filter.Search)).OrderByDescending(x => x.Created).ToList();

                    return list;
                }
                else
                {
                    var list = ctx.Adverts.OrderByDescending(x => x.Created).ToList();

                    return list;
                }

            }
        }

        public static List<Adverts> GetAdvertsForWithSearch(string search)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Adverts.OrderByDescending(x => x.Created).ToList();

                return list;
            }
        }

        public static List<spGetUserAdverts_Result> GetUserAdverts(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.spGetUserAdverts(userId).ToList();

                return list;
            }
        }

        public static int GetAdvertsActiveCount(SellFilter filter)
        {
            using (var ctx = new RentooloEntities())
            {
                if (!string.IsNullOrEmpty(filter.Search))
                {
                    int count = ctx.Adverts.Where(x => x.Name.Contains(filter.Search) || x.Description.Contains(filter.Search)).Count();

                    return count;
                }
                else
                {
                    int count = ctx.Adverts.Count();

                    return count;
                }
            }
        }

        #endregion
    }
}