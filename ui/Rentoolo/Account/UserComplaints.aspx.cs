using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class UserComplaints : BasicPage
    {
        public List<spGetComplaintsByRecipier_Result> ComplaintList = new List<spGetComplaintsByRecipier_Result>();
        protected void Page_Load(object sender, EventArgs e)
        {
            ComplaintList = DataHelper.GetComplaintsByRecipier(User.UserId);
        }
    }
}