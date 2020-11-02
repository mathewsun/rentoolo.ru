using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class UserComplaintView : System.Web.UI.Page
    {
        public Complaints Complaint;
        protected void Page_Load(object sender, EventArgs e)
        {
            Complaint = DataHelper.GetComplaint(Convert.ToInt32(Request.QueryString["id"]));
        }
    }
}