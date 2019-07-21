using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class DatabaseTables : System.Web.UI.Page
    {
        public List<fnGetTablesRows_Result> ListCounts;

        protected void Page_Load(object sender, EventArgs e)
        {
            ListCounts = DataHelper.GetTablesRowsCount();
        }
    }
}