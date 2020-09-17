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
        public int ViewsCount = 0;


        // TODO: fix add UserViews add bug


        protected void Page_Load(object sender, EventArgs e)
        {
            long id = Convert.ToInt64(Request.QueryString["id"]);

            if(id == 0)
            {
                Response.Redirect("/");
            }

            if (!IsPostBack)
            {

                ViewsCount = DataHelper.GetUserViewsCount((int)id, StructsHelper.ViewedType["product"]);

                var x = new UserViews()
                {
                    Date = DateTime.Now,
                    UserId = User.UserId,
                    Type = StructsHelper.ViewedType["product"],
                    ObjectId = (int)id

                };

                DataHelper.TryAddUserView(x);


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