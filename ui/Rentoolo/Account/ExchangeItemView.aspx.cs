using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class ExchangeItemView : System.Web.UI.Page
    {
        public ExchangeProducts ExchangeItem;
        public Adverts ExchangeAdvert;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];

            ExchangeItem = DataHelper.GetExchangeItem(Convert.ToInt64(id));
            ExchangeAdvert = AdvertsDataHelper.GetAdvert(ExchangeItem.AdvertId);

        }
    }
}