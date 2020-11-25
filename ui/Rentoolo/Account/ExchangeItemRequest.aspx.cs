using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class ExchangeItemRequest : System.Web.UI.Page
    {
        public Model.ExchangeItemRequests itemRequest;

        public Model.Adverts ExchangeAdvert;
        public Model.Adverts WantedAdvert;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];

            itemRequest = DataHelper.GetExchangeItemRequest(Convert.ToInt64(id));

            ExchangeProducts exchangeItem = DataHelper.GetExchangeItem(itemRequest.ExchangeItemId);
            ExchangeProducts wantedExchangeItem = DataHelper.GetExchangeItem(itemRequest.WantedExchangeItemId);

            ExchangeAdvert = AdvertsDataHelper.GetAdvert(exchangeItem.AdvertId);
            WantedAdvert = AdvertsDataHelper.GetAdvert(wantedExchangeItem.AdvertId);


        }
    }
}