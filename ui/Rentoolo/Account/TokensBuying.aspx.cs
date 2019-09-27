using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class TokensBuying : BasicPage
    {
        public List<Model.TokensBuying> ListItems;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = TokensDataHelper.GetAllTokensBuyingByUser(User.UserId);
            }
        }
    }
}