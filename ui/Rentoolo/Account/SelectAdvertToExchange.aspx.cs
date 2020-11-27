using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class SelectAdvertToExchange : BasicPage
    {

        public List<Model.Adverts> UserAdverts;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserAdverts = AdvertsDataHelper.GetAdverts(User.UserId);
        }
    }
}