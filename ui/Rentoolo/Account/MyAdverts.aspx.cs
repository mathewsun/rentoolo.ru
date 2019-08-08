using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class MyAdverts : BasicPage
    {
        public List<spGetUserAdverts_Result> ListItems;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = AdvertsDataHelper.GetUserAdverts(User.UserId);//.OrderBy(x => x.Created).ToList();
            }
        }
    }
}