using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class FavoritesHelper
    {
        public static List<Favorites> GetFavoritesByUser(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Favorites.Where(x => x.UserId == userId).ToList();

                return list;
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
    }
}