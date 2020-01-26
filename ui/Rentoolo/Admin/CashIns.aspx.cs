using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class CashIns : System.Web.UI.Page
    {
        public List<Model.CashIns> list;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                list = DataHelper.GetLast50CashIns();
            }
        }
    }
}