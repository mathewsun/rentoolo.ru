using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class News : System.Web.UI.Page
    {
        public List<Model.New> list;

        protected void Page_Load(object sender, EventArgs e)
        {
            list = DataHelper.GetNews();
        }
    }
}