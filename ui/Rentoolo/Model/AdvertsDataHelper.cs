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



        public static List<Adverts> GetAdvertsForMainPage(SellFilter filter)
        {
            // bool isEndDate is needed to undestand correctly startEndDate variable - if its true 
            // it means that startEndDate is endDate else startDate

            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Adverts.Select(x => x);
                if (filter.Search != null)
                {
                    if (filter.OnlyInName)
                    {
                        result = result.filterAdverts(filter.Search,true);
                    }
                    else
                    {
                        result = result.filterAdverts(filter.Search,false);
                    }
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

                if ((filter.EndPrice != null)&&(filter.EndPrice>=filter.StartPrice))
                {
                    result = result.filterAdverts((double)filter.EndPrice, false);
                }

                if (filter.City != null)
                {
                    result = result.filterAdverts(filter.City);
                }

                //if (filter.ByDate == true)
                //{
                //    result = result.OrderBy(x => x.Created);
                //}

                //if(filter.ByDateDesc==true)
                //{
                //    result = result.OrderByDescending(x => x.Created);
                //}

                //if (filter.ByPrice==true)
                //{
                //    result = result.OrderBy(x => x.Price);
                //}

                //if (filter.ByPriceDesc == true)
                //{
                //    result = result.OrderByDescending(x => x.Price);
                //}


                switch (filter.SortBy)
                {
                    case "by date":
                        result = result.OrderBy(x => x.Created);
                        break;
                    case "by price":
                        result = result.OrderBy(x => x.Price);
                        break;
                    case "by date descendance":
                        result = result.OrderByDescending(x => x.Created);
                        break;
                    case "by price descendance":
                        result = result.OrderByDescending(x => x.Price);
                        break;
                    default:
                        result = result.OrderBy(x => x.Created);
                        break;
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


        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, string city)
        {
            var list = adverts.Where(x => x.Address.Contains(city));
            return list;
        }


        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, string filter, bool onlyInName)
        {
            IQueryable<Adverts> list;
            if (onlyInName)
            {
                list = adverts.Where(x => x.Name.Contains(filter));
            }
            else
            {
                list = adverts.Where(x => x.Name.Contains(filter) || x.Description.Contains(filter));
            }
            
            return list;
        }


        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, SellFilter filter)
        {
            var list = adverts.Where(x => x.Name.Contains(filter.Search) || x.Description.Contains(filter.Search));
            return list;
        }

        static IQueryable<Adverts> filterAdverts(this IQueryable<Adverts> adverts, double startEndPrice, bool isStartPrice = true)
        {
            IQueryable<Adverts> list;
            if (isStartPrice)
            {
                list = adverts.Where(x => x.Price >= startEndPrice);
            }
            else
            {
                list = adverts.Where(x => x.Price <= startEndPrice);
            }
                
            return list;
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