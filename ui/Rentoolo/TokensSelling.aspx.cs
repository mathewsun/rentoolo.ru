using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class TokensSelling : System.Web.UI.Page
    {
        public List<Model.TokensSelling> ListItems;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = TokensDataHelper.GetAllTokensSelling();
            }
        }
    }
}