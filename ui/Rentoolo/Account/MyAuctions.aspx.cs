using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class MyAuctions : BasicPage
    {
        public List<AuctionsForPage> ListItems;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = AuctionsHelper.GetAuctions(User.UserId);
            }
        }
    }
}