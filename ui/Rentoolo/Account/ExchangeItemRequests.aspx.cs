using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class ExchangeItemRequests : System.Web.UI.Page
    {
        public List<Model.ExchangeItemRequests> ItemRequests;
        public Model.Adverts Advert;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            string advertId = Request.QueryString["advertId"];

            ItemRequests = DataHelper.GetExchangeItemRequests(Convert.ToInt64(id));

            Advert = AdvertsDataHelper.GetAdvert(Convert.ToInt64(advertId));
        }
    }
}