using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class Users : System.Web.UI.Page
    {
        public List<Model.fnGetAllUsersResult> List;

        public int HoursDifference;

        protected void Page_Load(object sender, EventArgs e)
        {
            HoursDifference = Convert.ToInt32(DataHelper.GetSettingByName("HoursDifference").Value);

            if (!IsPostBack)
            {
                List = DataHelper.GetAllUsers();
            }
        }
    }
}