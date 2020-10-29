using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class AdvertsDataHelper
    {
        #region Объявления

        public static TEntity Get<TEntity>(long id) where TEntity : class
        {
            using (var dc = new RentooloEntities())
            {
                var items = (DbSet<TEntity>) dc.GetType().GetProperty(typeof(TEntity).Name).GetValue(dc);
                var item = items.AsEnumerable().FirstOrDefault(x => Convert.ToInt64(typeof(TEntity).GetProperty("Id").GetValue(x))  == id);
                return item;
            }
        }
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




        public static List<Adverts> GetAdvertsForMainPage(SellFilter filter, DateTime startDate, DateTime endDate)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Adverts.Select(x => x);
                if (!string.IsNullOrEmpty(filter.Search))
                {
                    
                    list = list.filterAdverts(filter);
                    list = list.filterAdverts(startDate, endDate);
                    list = list.OrderByDescending(x => x.Created);

                    return list.ToList();
                }
                else
                {
                    list = list.filterAdverts(startDate, endDate);
                    list = (IQueryable<Adverts>)list.OrderByDescending(x => x.Created).ToList();

                    return list.ToList();
                }

            }
        }


        public static List<Adverts> GetAdvertsForMainPage(SellFilter filter, DateTime startEndDate, bool isEndDate = false)
        {
            // bool isEndDate is needed to undestand correctly startEndDate variable - if its true 
            // it means that startEndDate is endDate else startDate
            
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Adverts.Select(x => x);
                if (!string.IsNullOrEmpty(filter.Search))
                {
                    list = list.filterAdverts(filter);
                    list = list.filterAdverts(startEndDate, isEndDate);
                    list = list.OrderByDescending(x => x.Created);

                    return list.ToList();
                }
                else
                {
                    list = list.filterAdverts(startEndDate, isEndDate);
                    list = (IQueryable<Adverts>)list.OrderByDescending(x => x.Created);

                    return list.ToList();
                }

            }
        }


        public static List<Adverts> GetAdvertsForMainPage(TestSellFilter filter)
        {
            // bool isEndDate is needed to undestand correctly startEndDate variable - if its true 
            // it means that startEndDate is endDate else startDate

            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Adverts.Select(x => x);
                if (filter.Search != null)
                {
                    result = result.filterAdverts(filter.Search);
                }

                if (filter.StartDate != null)
                {
                    result = result.filterAdverts((DateTime)filter.StartDate, false);
                }

                if (filter.EndDate != null)
                {
                    result = result.filterAdverts((DateTime)filter.EndDate, true);
                }

                if (filter.StartPrice != null)
                {
                    result = result.filterAdverts((double)filter.StartPrice, true);
                }

                if (filter.EndPrice != null)
                {
                    result = result.filterAdverts((double)filter.EndPrice, false);
                }
                return result.ToList();
            }
        }









        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts,DateTime startDate, DateTime endDate)
        {
            return adverts.Where(x => x.Created >= startDate && x.Created <= endDate);
        }

        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, DateTime startEndDate, bool isEndDate = false)
        {
            if (isEndDate)
            {
                return adverts.Where(x => x.Created <= startEndDate);
            }
            else
            {
                return adverts.Where(x => x.Created >= startEndDate);
            }
            
        }





        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, string filter)
        {
            var list = adverts.Where(x => x.Name.Contains(filter) || x.Description.Contains(filter)).OrderByDescending(x => x.Created);
            return list;
        }


        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, SellFilter filter)
        {
            var list = adverts.Where(x => x.Name.Contains(filter.Search) || x.Description.Contains(filter.Search)).OrderByDescending(x => x.Created);
            return list;
        }

        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, double startEndPrice, bool isStartPrice = true)
        {
            IQueryable<Adverts> list;
            if (isStartPrice)
            {
                list = adverts.Where(x => x.Price >= startEndPrice).OrderByDescending(x => x.Created);
            }
            else
            {
                list = adverts.Where(x => x.Price <= startEndPrice).OrderByDescending(x => x.Created);
            }
                
            return list;
        }

        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, double startPrice, double endPrice)
        {
            IQueryable<Adverts> list;

            list = adverts.filterAdverts(startPrice, true);
            list = list.filterAdverts(endPrice, false);

            return list;
        }

        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, bool onlyInName)
        {
            IQueryable<Adverts> list;


            return null;
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

        public static int GetActiveCount<TEntity>(SellFilter filter = null) where TEntity : class
        {
            using (var ctx = new RentooloEntities())
            {
                var items = (DbSet<TEntity>)ctx.GetType().GetProperty(typeof(TEntity).Name).GetValue(ctx);

                if (!string.IsNullOrEmpty(filter?.Search))
                {
                    var count = items.AsEnumerable().Where(x =>
                            typeof(TEntity).GetProperty("Name").GetValue(x).ToString().
                                Contains(filter.Search) 
                            || typeof(TEntity).GetProperty("Description").GetValue(x).ToString().
                                Contains(filter.Search)).Count();

                    return count;
                }
                else
                {
                    return items.Count();
                }

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