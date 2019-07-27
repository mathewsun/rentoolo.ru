using System;
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class FavoritesHelper
    {
        public static void AddFavorites(Favorites item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Favorites.Add(item);
                ctx.SaveChanges();
            }
        }

        public static List<FavoritesForPage> GetFavoritesByUser(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.spGetFavorites(userId);

                List<FavoritesForPage> list = new List<FavoritesForPage>();

                foreach (var item in result)
                {
                    list.Add(new FavoritesForPage
                    {
                        Id = item.Id,
                        AdvertId = item.AdvertId,
                        CreatedFavorites = item.CreatedFavorites,
                        Category = item.Category,
                        Name = item.Name,
                        Description = item.Description,
                        CreatedAdverts = item.CreatedAdverts.Value,
                        CreatedUserId = item.CreatedUserId.Value,
                        Price = item.Price.Value,
                        Address = item.Address,
                        Phone = item.Phone,
                        MessageType = item.MessageType.Value,
                        Position = item.PositionString
                    });
                }

                return list;
            }
        }

        public static void DeleteFavorites(long id)
        {
            using (var ctx = new RentooloEntities())
            {
                Favorites obj = ctx.Favorites.Single(x => x.Id == id);

                ctx.Favorites.Remove(obj);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }

        public static void AddFavoritesByCookies(FavoritesByCookies item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.FavoritesByCookies.Add(item);
                ctx.SaveChanges();
            }
        }

        public static List<FavoritesForPage> GetFavoritesByCookies(string uid)
        {
            using (var ctx = new RentooloEntities())
            {
                System.Data.Objects.ObjectResult<spGetFavoritesByCookies_Result> result = ctx.spGetFavoritesByCookies(uid);

                List<FavoritesForPage> list = new List<FavoritesForPage>();

                foreach (var item in result)
                {
                    list.Add(new FavoritesForPage
                    {
                        Id = item.Id,
                        AdvertId = item.AdvertId,
                        CreatedFavorites = item.CreatedFavorites,
                        Category = item.Category,
                        Name = item.Name,
                        Description = item.Description,
                        CreatedAdverts = item.CreatedAdverts.Value,
                        CreatedUserId = item.CreatedUserId.Value,
                        Price = item.Price.Value,
                        Address = item.Address,
                        Phone = item.Phone,
                        MessageType = item.MessageType.Value,
                        Position = item.PositionString
                    });
                }

                return list;
            }
        }

        //public static List<Favorites> GetFavoritesListByCookies(string uid)
        //{
        //    var list = GetFavoritesByCookies(uid);

        //    List<Favorites> favoritesList = new List<Favorites>();

        //    foreach (var item in list)
        //    {
        //        favoritesList.Add(new Favorites
        //        {
        //            AdvertId = item.AdvertId,
        //            Created = item.Created
        //        });
        //    }

        //    return favoritesList;
        //}

        public static void DeleteFavoritesByCookies(long id)
        {
            using (var ctx = new RentooloEntities())
            {
                FavoritesByCookies obj = ctx.FavoritesByCookies.Single(x => x.Id == id);

                ctx.FavoritesByCookies.Remove(obj);

                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }
    }
}