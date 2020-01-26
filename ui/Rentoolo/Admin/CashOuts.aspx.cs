using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class CashOuts : System.Web.UI.Page
    {
        public List<Model.CashOuts> list;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.Params["userid"]))
                {
                    try
                    {
                        Guid userId = new Guid(Request.Params["userid"]);

                        list = DataHelper.GetUser50CashOuts(userId);
                    }
                    catch (System.Exception ex)
                    {
                        DataHelper.AddException(ex);
                    }
                }
                else
                {
                    list = DataHelper.GetAllCashOuts();
                }
            }
        }
    }
}