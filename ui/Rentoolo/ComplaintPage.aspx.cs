using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model.HelperStructs;

namespace Rentoolo
{
    public partial class ComplaintPage : System.Web.UI.Page
    {
        public Complaints Complaint = new Complaints();
        public string ComplaintTypeName = "";
        public string ComplaintObjTypeName = "";
        public string UserSender = "";
        public string UserReciever = "";

        protected void Page_Load(object sender, EventArgs e)
        {

            Complaint = DataHelper.GetComplaint(Convert.ToInt32(Request.QueryString["id"]));
            if (Complaint == null)
            {
                int complaintType = Convert.ToInt32(Request.QueryString["complaintType"]);
                int complaintObjectType = Convert.ToInt32(Request.QueryString["complaintObjectType"]);

                Complaint =  DataHelper.GetComplaint(complaintType, complaintObjectType);

            }

            ComplaintTypeName = StructsHelper.ComplaintTypeName[Complaint.СomplaintType];
            ComplaintObjTypeName = StructsHelper.ComplaintObjTypeName[Complaint.ObjectType];

            UserReciever = DataHelper.GetUser(Complaint.UserRecipier).UserName;
            UserSender = DataHelper.GetUser(Complaint.UserSender).UserName;


        }
    }
}