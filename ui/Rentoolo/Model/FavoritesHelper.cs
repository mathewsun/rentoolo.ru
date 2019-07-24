using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

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

        public static List<Favorites> GetFavoritesByUser(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Favorites.Where(x => x.UserId == userId).ToList();

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

        public static List<FavoritesByCookies> GetFavoritesByCookies(string uid)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.FavoritesByCookies.Where(x => x.Value == uid).ToList();

                return list;
            }
        }

        public static List<Favorites> GetFavoritesListByCookies(string uid)
        {
            var list = GetFavoritesByCookies(uid);

            List<Favorites> favoritesList = new List<Favorites>();

            foreach (var item in list)
            {
                favoritesList.Add(new Favorites
                {
                    AdvertId = item.AdvertId,
                    Created = item.Created
                });
            }

            return favoritesList;
        }

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