using System;
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class FavoritesHelper
    {
        #region Auctions

        public static void AddFavoritesAuctions(FavoritesAuctions item)
        {
            using (var ctx = new RentooloEntities())
            {
                try
                {
                    var id = ctx.spAddFavoritesAuctions(item.UserId, item.AuctionId);

                    //return id.value;
                    var result = id.FirstOrDefault();

                    if (result != null)
                    {
                        decimal resultId = result.Value;
                    }
                }
                catch (Exception e) { }
            }
        }

        public static void AddFavoritesAuctionsSQL()
        {
            using (var ctx = new RentooloEntities())
            {
                //var results = ctx.Database.SqlQuery<Auctions>("select * from Auctions where id = 3").FirstOrDefault();

                var results2 = ctx.Database.SqlQuery<Auctions>("select * from Auctions").ToList();
                // ctx.spAddFavoritesAuctions(item.UserId, item.AuctionId);
                //return results;
            }
        }

        public static void AddFavoritesAuctionsByCookies(FavoritesAuctionsByCookies item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.spAddFavoritesAuctionsByCookies(item.UserCookiesId, item.AuctionId);
            }
        }
        #endregion


        public static void AddFavorites(Favorites item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.spAddFavorites(item.UserId, item.AdvertId);
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
                        Position = item.PositionString,
                        ImgUrls = item.ImgUrls
                    });
                }

                return list;
            }
        }

        public static List<FavoritesForPage> GetFavoritesByUserEF(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                List<Favorites> result = ctx.Favorites.Where(x => x.UserId == userId).ToList();

                List<FavoritesForPage> list = new List<FavoritesForPage>();

                foreach (var item in result)
                {
                    list.Add(new FavoritesForPage
                    {
                        Id = item.Id,
                        AdvertId = item.AdvertId,
                        //CreatedFavorites = item.CreatedFavorites,
                        //Category = item.Category,
                        //Name = item.Name,
                        //Description = item.Description,
                        //CreatedAdverts = item.CreatedAdverts.Value,
                        //CreatedUserId = item.CreatedUserId.Value,
                        //Price = item.Price.Value,
                        //Address = item.Address,
                        //Phone = item.Phone,
                        //MessageType = item.MessageType.Value,
                        //Position = item.PositionString
                    });
                }

                return list;
            }
        }

        public static List<FavoritesForPage> GetFavoritesByUserSqlQuery(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                string query = string.Format("SELECT * FROM Favorites WHERE UserId = '{0}'", userId);

                var result = ctx.Database.SqlQuery<FavoritesForPage>(query).ToList();

                List<FavoritesForPage> list = new List<FavoritesForPage>();

                foreach (var item in result)
                {
                    list.Add(new FavoritesForPage
                    {
                        Id = item.Id,
                        AdvertId = item.AdvertId,
                        //CreatedFavorites = item.CreatedFavorites,
                        //Category = item.Category,
                        //Name = item.Name,
                        //Description = item.Description,
                        //CreatedAdverts = item.CreatedAdverts.Value,
                        //CreatedUserId = item.CreatedUserId.Value,
                        //Price = item.Price.Value,
                        //Address = item.Address,
                        //Phone = item.Phone,
                        //MessageType = item.MessageType.Value,
                        //Position = item.PositionString
                    });
                }

                return list;
            }
        }

        public static void DeleteFavorites(long favoritesId, Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                Favorites obj = ctx.Favorites.Single(x => x.Id == favoritesId && x.UserId == userId);

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
                ctx.spAddFavoritesByCookies(item.UserCookiesId, item.AdvertId);
            }
        }

        public static List<FavoritesForPage> GetFavoritesByCookies(string uid)
        {
            using (var ctx = new RentooloEntities())
            {
                System.Data.Entity.Core.Objects.ObjectResult<spGetFavoritesByCookies_Result> result = ctx.spGetFavoritesByCookies(uid);

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

        public static void DeleteFavoritesByCookies(long favoritesId, string userCookieId)
        {
            using (var ctx = new RentooloEntities())
            {
                FavoritesByCookies obj = ctx.FavoritesByCookies.Single(x => x.Id == favoritesId && x.UserCookiesId == userCookieId);

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