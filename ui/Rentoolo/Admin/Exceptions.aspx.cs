using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class Exceptions : System.Web.UI.Page
    {
        public List<Model.Exceptions> ListItems;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                ListItems = DataHelper.GetExceptionsLast100();
            }
        }
    }
}