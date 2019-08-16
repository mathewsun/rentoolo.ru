using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Auctions : BasicPage
    {
        public List<Model.AuctionsForPage> ListItems;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Users user = DataHelper.GetUser(User.UserId);
                if (User != null)
                {
                    ListItems = Model.AuctionsHelper.GetAuctions(User.UserId);
                }
            }
        }
    }
}
