using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class TokensOperations : System.Web.UI.Page
    {
        public List<Model.spGetLast200TokensOperations_Result> ListItems;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = TokensDataHelper.GetLast200TokensOperations();
            }
        }
    }
}