using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class Payments : System.Web.UI.Page
    {
        public List<Model.Payments> List;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.Params["userid"]))
                {
                    try
                    {
                        Guid userId = new Guid(Request.Params["userid"]);

                        List = DataHelper.GetUserRecepientPayments(userId);
                    }
                    catch (System.Exception ex)
                    {
                        DataHelper.AddException(ex);
                    }
                }
                else
                {
                    List = DataHelper.GetLast100Payments();
                }
            }
        }
    }
}