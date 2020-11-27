using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class ExchangeItemRequest : BasicPage
    {
        public Model.ExchangeItemRequests itemRequest;

        public Model.Adverts ExchangeAdvert;
        public Model.Adverts WantedAdvert;

        ExchangeProducts wantedExchangeItem;

        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];

            itemRequest = DataHelper.GetExchangeItemRequest(Convert.ToInt64(id));

            ExchangeProducts exchangeItem = DataHelper.GetExchangeItem(itemRequest.ExchangeItemId);
            wantedExchangeItem = DataHelper.GetExchangeItem(itemRequest.WantedExchangeItemId);

            ExchangeAdvert = AdvertsDataHelper.GetAdvert(exchangeItem.AdvertId);
            WantedAdvert = AdvertsDataHelper.GetAdvert(wantedExchangeItem.AdvertId);


        }

        protected void ButtonAcceptRequest_Click(object sender, EventArgs e)
        {
            bool isDebug = true;

            if(User.UserId == WantedAdvert.CreatedUserId || isDebug)
            {
                DataHelper.SetExchangeProductRequest(itemRequest, wantedExchangeItem);
            }

        }
    }
}