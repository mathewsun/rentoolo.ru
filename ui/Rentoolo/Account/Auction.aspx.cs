using Newtonsoft.Json;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class Auction : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Model.Auctions item = new Model.Auctions();

            var objPhotos = Request.Form["AuctionPhotos"];

            if (objPhotos != null)
            {
                String[] listPhotos = objPhotos.Split(',');

                var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

                item.ImgUrls = jsonPhotos;
            }
            else
            {
                item.ImgUrls = "[\"/img/a/noPhoto.png\"]";
            }

            item.Name = TextBoxName.Text;

            item.StartPrice = decimal.Parse(TextBoxPrice.Text);

            item.Description = TextBoxDescription.Text;

            item.UserId = User.UserId;

            item.Created = DateTime.Now;

            item.DataEnd = DateTime.Parse(TextBoxDataEnd.Text);

            AuctionsHelper.AddAuction(item);

            Response.Redirect("/Account/Auctions.aspx");
        }
    }
}