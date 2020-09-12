using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using Rentoolo.Model;
using System.Web.SessionState;

namespace Rentoolo
{
    /// <summary>
    /// Сводное описание для Events
    /// </summary>
    public class Events : IHttpHandler, IReadOnlySessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string eventName = string.Empty;
            string result = string.Empty;
            string id = string.Empty;
            string comment = string.Empty;

            eventName = context.Request["e"];
            result = context.Request["r"];
            id = context.Request["id"];
            comment = context.Request["c"];

            ///Add favorites
            if (eventName == "af")
            {
                string userName = context.User.Identity.Name;

                if (!string.IsNullOrEmpty(userName))
                {
                    Users user = DataHelper.GetUserByName(userName);

                    Rentoolo.Model.Favorites favorites = new Rentoolo.Model.Favorites
                    {
                        UserId = user.UserId,
                        AdvertId = Convert.ToInt64(id)
                    };

                    FavoritesHelper.AddFavorites(favorites);
                }
                else
                {
                    var uid = context.Request.Cookies["uid"];

                    if (uid != null)
                    {
                        FavoritesByCookies favoritesByCookies = new FavoritesByCookies
                        {
                            UserCookiesId = uid.Value,
                            AdvertId = Convert.ToInt64(id)
                        };

                        FavoritesHelper.AddFavoritesByCookies(favoritesByCookies);
                    }
                }
            }

            ///Remove favorites
            if (eventName == "rf")
            {
                string userName = context.User.Identity.Name;

                if (!string.IsNullOrEmpty(userName))
                {
                    Users user = DataHelper.GetUserByName(userName);

                    long advertId = Convert.ToInt64(id);

                    FavoritesHelper.DeleteFavorites(advertId, user.UserId);
                }
                else
                {
                    var uid = context.Request.Cookies["uid"];

                    if (uid != null)
                    {
                        long advertId = Convert.ToInt64(id);

                        FavoritesHelper.DeleteFavoritesByCookies(advertId, uid.Value);
                    }
                }
            }

            ///Add favoritesAuctions
            if (eventName == "afa")
            {
                string userName = context.User.Identity.Name;

                //if (!string.IsNullOrEmpty(userName))
                //{
                //    Users user = DataHelper.GetUserByName(userName);

                //    Rentoolo.Model.FavoritesAuctions favorites = new Rentoolo.Model.FavoritesAuctions
                //    {
                //        UserId = user.UserId,
                //        AuctionId = Convert.ToInt64(id),
                //        Created = DateTime.Now
                //    };

                //   // FavoritesHelper.AddFavoritesAuctionsSQL();

                //  FavoritesHelper.AddFavoritesAuctions(favorites);
                //}
                //else
                //{
                //    var uid = context.Request.Cookies["uid"];

                //    if (uid != null)
                //    {
                //        FavoritesAuctionsByCookies favoritesByCookies = new FavoritesAuctionsByCookies
                //        {
                //            UserCookiesId = uid.Value,
                //            AuctionId = Convert.ToInt64(id)
                //        };

                //        FavoritesHelper.AddFavoritesAuctionsByCookies(favoritesByCookies);
                //    }
                //}
            }

            if (eventName == "saveUserParam")
            {
                if (id == "Referrer")
                {
                    Model.Users referal = DataHelper.GetUserByName(context.User.Identity.Name);

                    int publicId;

                    if (!int.TryParse(result, out publicId)) return;

                    Model.Users referer = DataHelper.GetUserByPublicId(publicId);

                    if (referer == null) return;

                    //сделать проверку что не является рефералом реферера и на уровень выше тоже

                    if (referer.UserId == referal.UserId) return;

                    Model.Referrals upperReferal = DataHelper.GetReferral(referer.UserId);

                    if (upperReferal != null && upperReferal.ReferrerUserId == referal.UserId) return;

                    if (upperReferal != null)
                    {
                        Model.Referrals upper2Referal = DataHelper.GetReferral(upperReferal.ReferrerUserId);

                        if (upper2Referal != null && upper2Referal.ReferrerUserId == referal.UserId) return;
                    }

                    Model.Referrals referralItem = new Model.Referrals
                    {
                        ReferralUserId = referal.UserId,
                        ReferrerUserId = referer.UserId,
                        WhenDate = DateTime.Now
                    };

                    DataHelper.AddReferral(referralItem);
                }

                if (id == "Email")
                {
                    DataHelper.UpdateUserEmail(context.User.Identity.Name, result);
                }
                else
                {
                    DataHelper.UpdateUserParametr(context.User.Identity.Name, id, result);
                }
            }

            context.Response.ContentType = "text/plain";
            context.Response.Write("Ok");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}