using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Membership.OpenAuth;
using DotNetOpenAuth.GoogleOAuth2;

namespace Rentoolo
{
    internal static class AuthConfig
    {
        public static void RegisterOpenAuth()
        {
            // See http://go.microsoft.com/fwlink/?LinkId=252803 for details on setting up this ASP.NET
            // application to support logging in via external services.

            //OpenAuth.AuthenticationClients.AddTwitter(
            //    consumerKey: "your Twitter consumer key",
            //    consumerSecret: "your Twitter consumer secret");

            //OpenAuth.AuthenticationClients.AddFacebook(
            //    appId: "your Facebook app id",
            //    appSecret: "your Facebook app secret");

            //OpenAuth.AuthenticationClients.AddMicrosoft(
            //    clientId: "your Microsoft account client id",
            //    clientSecret: "your Microsoft account client secret");

            //OpenAuth.AuthenticationClients.AddGoogle();
            var client = new GoogleOAuth2Client("337461708184-a40ahhpbvn24h2ub6gbqn6ljn2h1ath9.apps.googleusercontent.com",
                "iDDgWvaWH6RdOMUzdWAyfLpP");
            var extraData = new Dictionary<string, string>();
            OpenAuth.AuthenticationClients.Add("Google", () => client, extraData);
        }
    }
}