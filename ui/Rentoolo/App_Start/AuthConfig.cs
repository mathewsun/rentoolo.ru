using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Membership.OpenAuth;
using DotNetOpenAuth.GoogleOAuth2;
using DotNetOpenAuth.FacebookOAuth2;

namespace Rentoolo
{
    internal static class AuthConfig
    {
        public static void RegisterOpenAuth()
        {
            var extraData = new Dictionary<string, string>();
            // See http://go.microsoft.com/fwlink/?LinkId=252803 for details on setting up this ASP.NET
            // application to support logging in via external services.

            //OpenAuth.AuthenticationClients.AddTwitter(
            //    consumerKey: "your Twitter consumer key",
            //    consumerSecret: "your Twitter consumer secret");

            var clientF = new FacebookOAuth2Client("748096399254392",
                "38c86be9252aba1dde6307ba114c4a79");
            OpenAuth.AuthenticationClients.Add("Facebook", () => clientF, extraData);

            //OpenAuth.AuthenticationClients.AddMicrosoft(
            //    clientId: "your Microsoft account client id",
            //    clientSecret: "your Microsoft account client secret");

            //OpenAuth.AuthenticationClients.AddGoogle();
            var clientG = new GoogleOAuth2Client("337461708184-a40ahhpbvn24h2ub6gbqn6ljn2h1ath9.apps.googleusercontent.com",
                "iDDgWvaWH6RdOMUzdWAyfLpP");

            OpenAuth.AuthenticationClients.Add("Google", () => clientG, extraData);
        }
    }
}