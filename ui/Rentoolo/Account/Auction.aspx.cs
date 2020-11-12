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
        Model.Auctions CurrentAuction=null;
        int auctionId;
        protected void Page_Load(object sender, EventArgs e)
        {
            string auctionId = Request.QueryString["auctionId"];
            int? id = auctionId == null ? null : (int?)Convert.ToInt32(auctionId);

            
            if (id != null)
            {
                CurrentAuction = AuctionsHelper.GetAuction((int)id);
                this.auctionId = (int)id;

                TextBoxDescription.Text = CurrentAuction.Description;
                TextBoxName.Text = CurrentAuction.Name;
                TextBoxPrice.Text = CurrentAuction.StartPrice.ToString();
                TextBoxDataEnd.Text = CurrentAuction.DataEnd.ToString();
            }

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
            try
            {
                item.DataEnd = DateTime.Parse(TextBoxDataEnd.Text);
            }catch(Exception ex)
            {
                
            }

            if (CurrentAuction != null)
            {
                AuctionsHelper.UpdateAuction(item, auctionId);
            }
            else
            {
                AuctionsHelper.AddAuction(item);
            }
                

            Response.Redirect("/Account/Auctions.aspx");
        }
    }
}