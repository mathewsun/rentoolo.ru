using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using Rentoolo;
using System.Web.Http;

namespace Rentoolo
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterOpenAuth();

            RegisterRoutes(RouteTable.Routes);

        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs

        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = System.Web.Http.RouteParameter.Optional }
            );

            routes.MapPageRoute("advertsRoute",
                "Adverts/{id}",
                "~/Adverts.aspx");

            routes.MapPageRoute("addItemRoute",
                "AddItem",
                "~/Account/AddItem.aspx");

            routes.MapPageRoute("addRoute",
                "Add",
                "~/Account/AddItem.aspx");

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

            routes.MapPageRoute("signupRoute",
                "Account/SignUp",
                "~/Account/SignUp.aspx");

            routes.MapPageRoute("TransportRoute",
                "Account/Transport",
                "~/Account/Transport.aspx");

            routes.MapPageRoute("MotoRoute",
                "Account/Moto",
                "~/Account/Moto.aspx");

            routes.MapPageRoute("favoritesRoute",
                "Favorites",
                "~/Favorites.aspx");

            routes.MapPageRoute("newsRoute",
                "news",
                "~/News.aspx");

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


        }
    }
}
