using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class AuctionInfo : BasicPage
    {
        public Model.Auctions AuctionItem;
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            AuctionItem = AuctionsHelper.GetAuction(id);
        }

        protected void ButtonCreateAuctionRequest_Click(object sender, EventArgs e)
        {
            decimal price = Convert.ToDecimal(TextBox2.Text);
            AuctionsHelper.AddAuctionRequest(new Model.AuctionRequests()
            {
                Name = TextBox1.Text,
                Price = price,
                Description = TextBox3.Text,
                UserId = User.UserId,
                AuctionId = AuctionItem.Id
            });

        }
    }
}