using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Watched : BasicPage
    {
        public List<FavoritesForPage> ListItems;

        public int ListCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Users user = DataHelper.GetUser(User.UserId);
                if (User != null)
                {
                    ListItems = WatchedHelper.GetWatchedByUser(User.UserId);
                }
                else
                {
                    if (Request.Cookies["uid"] != null)
                    {
                        string value = Request.Cookies["uid"].Value;

                        ListItems = WatchedHelper.GetWatchedByCookies(value);
                    }
                }

                ListCount = ListItems.Count;
            }
        }
    }
}