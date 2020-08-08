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

            item.Name = TextBoxName.Text;

            item.StartPrice = decimal.Parse(TextBoxPrice.Text);

            item.Description = TextBoxDescription.Text;

            item.UserId = User.UserId;

            item.Created = DateTime.Now;

            AuctionsHelper.AddAuction(item);

            Response.Redirect("/Account/Auctions.aspx");
        }
    }
}