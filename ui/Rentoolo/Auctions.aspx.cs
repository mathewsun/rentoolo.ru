using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class Auctions : Page
    {
        public List<Model.Auctions> ListItems;
        public string AuctionsCount { get; private set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = AuctionsHelper.GetAllAuctions();

                AuctionsCount = AuctionsHelper.GetAuctionsActiveCount().ToString("N0");
            }
        }
    }
}