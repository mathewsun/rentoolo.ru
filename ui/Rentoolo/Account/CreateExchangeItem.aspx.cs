using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class CreateExchangeItem : BasicPage
    {
        Adverts advert;
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];

            advert = AdvertsDataHelper.GetAdvert(Convert.ToInt64(id));

        }

        protected void ButtonCreate_Click(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];

            string comment = Request.Form["comment"];
            string header = Request.Form["wanted"];
            string wanted = Request.Form["wanted"];

            DataHelper.AddExchangeItem(new ExchangeProducts()
            {
                WantedObject = wanted,
                Header = header,
                Comment = comment,
                AdvertId = Convert.ToInt64(id)

            }, User.UserId); 

        }
    }
}