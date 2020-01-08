using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class Advert : BasicPage
    {
        public Adverts AdvertItem;

        protected void Page_Load(object sender, EventArgs e)
        {
            long id = Convert.ToInt64(Request.QueryString["id"]);

            if(id == 0)
            {
                Response.Redirect("/");
            }

            if (!IsPostBack)
            {
                AdvertItem = AdvertsDataHelper.GetAdvert(id);

                if (User != null)
                {
                    WatchedDataHelper.AddWatched(User.UserId, id);
                }
                else
                {
                    if (Request.Cookies["uid"] != null)
                    {
                        string value = Request.Cookies["uid"].Value;

                        WatchedDataHelper.AddWatchedByCookies(value, id);
                    }
                }
                
            }

            string tempId = Page.RouteData.Values["id"] as string;
        }
    }
}