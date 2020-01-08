using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class WatchedDataHelper
    {
        public static void AddWatched(Guid userId, long advertId)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.spAddWatched(userId, advertId);
            }
        }

        public static void AddWatchedByCookies(string userCookiesId, long advertId)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.spAddWatchedByCookies(userCookiesId, advertId);
            }
        }

        public static List<FavoritesForPage> GetWatchedByUser(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.spGetWatched(userId);

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
                        Position = item.PositionString,
                        ImgUrls = item.ImgUrls
                    });
                }

                return list;
            }
        }
        
        public static List<FavoritesForPage> GetWatchedByCookies(string uid)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.spGetWatchedByCookies(uid);

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
                        Position = item.PositionString,
                        ImgUrls = item.ImgUrls
                    });
                }

                return list;
            }
        }
    }
}