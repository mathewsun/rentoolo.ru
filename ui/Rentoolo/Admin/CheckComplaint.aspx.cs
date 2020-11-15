using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Admin
{
    public partial class CheckComplaint : System.Web.UI.Page
    {
        public Model.Complaints Complaint = new Complaints();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            Complaint = DataHelper.GetComplaint(Convert.ToInt32(id));

        }

        protected void ButtonChangeStatus_Click(object sender, EventArgs e)
        {
            string status = Request.Form["status"];
            DataHelper.SetComplaintStatus(Complaint.Id, status);
        }
    }
}