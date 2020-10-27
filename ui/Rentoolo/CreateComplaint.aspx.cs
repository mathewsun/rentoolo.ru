using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class CreateComplaint : BasicPage
    {
        public string ComplaintTypeName = "";
        public string ComplaintObjTypeName = "";
        int complaintType;
        int complaintObjectType;
        Guid userSender;
        Guid userRecivier;
        int objectId;
        protected void Page_Load(object sender, EventArgs e)
        {
            
            complaintObjectType = Convert.ToInt32(Request.QueryString["complaintObjectType"]);

            userSender = User.UserId;
            userRecivier = Guid.Parse(Request.QueryString["userRecivier"]);

            objectId = Convert.ToInt32(Request.QueryString["objectId"]);
        }

        protected void ButtonCreateComplaint_Click(object sender, EventArgs e)
        {
            string message = Request.Form["message"];
            complaintType = Convert.ToInt32(Request.Form["complaintType"]);

            Complaints complaint = new Complaints()
            {
                Message = message,
                СomplaintType = complaintType,
                ObjectType = complaintObjectType,
                UserSender = userSender,
                UserRecipier = userRecivier,
                Data = DateTime.Now,
                ObjectId = objectId
            };

            DataHelper.AddComplaint(complaint);

        }
    }
}