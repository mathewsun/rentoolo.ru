using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class AuctionRequests : System.Web.UI.Page
    {
        public List<Model.AuctionRequests> AuctionRequestList = new List<Model.AuctionRequests>();
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);
            AuctionRequestList = AuctionsHelper.GetRequests(id);
        }
    }
}