using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class Referrals : System.Web.UI.Page
    {
        public List<Model.Referrals> ListItems;

        public int HoursDifference;

        protected void Page_Load(object sender, EventArgs e)
        {
            HoursDifference = Convert.ToInt32(DataHelper.GetSettingByName("HoursDifference").Value);

            if (!IsPostBack)
            {
                string userId = Request.Params["userid"];

                if (!string.IsNullOrEmpty(userId))
                {
                    ListItems = DataHelper.GetUserReferrals(new Guid(userId));
                }
                else
                {
                    ListItems = DataHelper.GetAllReferrals();
                }
            }
        }
    }
}