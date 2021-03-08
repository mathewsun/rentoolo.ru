using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace Rentoolo
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);

            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");


            routes.MapPageRoute("advertsRoute",
                "Adverts/{id}",
                "~/Adverts.aspx");

            routes.MapPageRoute("addItemRoute",
                "AddItem",
                "~/Account/AddItem.aspx");

            routes.MapPageRoute("addRoute",
                "Add",
                "~/Account/AddItem.aspx");

            routes.MapPageRoute("addAuctionRoute",
                "Account/Auction",
                "~/Account/Auction.aspx");

            routes.MapPageRoute("autoRoute",
                "Account/Auto",
                "~/Account/Auto.aspx");

            routes.MapPageRoute("cabinetRoute",
                "Account/Cabinet",
                "~/Account/Cabinet.aspx");

            routes.MapPageRoute("cashInRoute",
                "Account/CashIn",
                "~/Account/CashIn.aspx");

            routes.MapPageRoute("CategoryRoute",
                "Account/Category",
                "~/Account/Category.aspx");

            routes.MapPageRoute("loginRoute",
                "Account/Login",
                "~/Account/Login.aspx");

            routes.MapPageRoute("RegisterExternalLogin",
                "Account/RegisterExternalLogin",
                "~/Account/RegisterExternalLogin.aspx");

            routes.MapPageRoute("rentAddItemRoute",
                "Account/Rent",
                "~/Account/Rent.aspx");

            routes.MapPageRoute("accountSellCategoryRoute",
                "Account/SellCategory",
                "~/Account/SellCategory.aspx");

            routes.MapPageRoute("signupRoute",
                "Account/SignUp",
                "~/Account/SignUp.aspx");

            routes.MapPageRoute("TransportRoute",
                "Account/Transport",
                "~/Account/Transport.aspx");

            routes.MapPageRoute("MotoRoute",
                "Account/Moto",
                "~/Account/Moto.aspx");

            routes.MapPageRoute("AuctionsRoute",
                "Auctions",
                "~/Auctions.aspx");

            routes.MapPageRoute("favoritesRoute",
                "Favorites",
                "~/Favorites.aspx");

            routes.MapPageRoute("newsRoute",
                "news",
                "~/News.aspx");

            routes.MapPageRoute("rentRoute",
                "Rent",
                "~/Rent.aspx");

            routes.MapPageRoute("testRoute",
                "test",
                "~/Test.aspx");

            routes.MapPageRoute("tokensRoute",
                "tokens",
                "~/Tokens.aspx");

            routes.MapPageRoute("TokensBuyingRoute",
                "TokensBuying",
                "~/TokensBuying.aspx");

            routes.MapPageRoute("TokensCostRoute",
                "TokensCost",
                "~/TokensCost.aspx");

            routes.MapPageRoute("tokensOperationsRoute",
                "tokensOperations",
                "~/TokensOperations.aspx");

            routes.MapPageRoute("TokensSellingRoute",
                "TokensSelling",
                "~/TokensSelling.aspx");


            routes.MapRoute(
                    name: "Default",
                    url: "{controller}/{action}/{id}",
                    defaults: new { action = "Index", id = UrlParameter.Optional }
                );
        }
    }
}
