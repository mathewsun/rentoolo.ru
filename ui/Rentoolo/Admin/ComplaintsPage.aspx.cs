using Rentoolo.Model;
using Rentoolo.Model.HelperStructs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Admin
{
    public partial class ComplaintsPage : System.Web.UI.Page
    {
        public List<Model.Complaints> Complaints;
        protected void Page_Load(object sender, EventArgs e)
        {
            string objectId = Request.QueryString["objectId"];
            string objectType = Request.QueryString["objectType"];
            string userSender = Request.QueryString["userSender"];
            string userRecipie = Request.QueryString["userRecipie"];
            string status = Request.QueryString["status"];

            Model.ComplaintsFilter filter = new ComplaintsFilter()
            {
                ObjectId = objectId == null || objectId == "" ? null : (int?)Convert.ToInt32(objectId),
                ObjectType = objectType == null || objectType == "" ? null : (int?)Convert.ToInt32(objectType),
                UserSender = userSender == null || userSender == "" ? null : (Guid?)Guid.Parse(userSender),
                UserRecipier = userRecipie == null || userRecipie == "" ? null : (Guid?)Guid.Parse(userRecipie),
                Status = status == null ? null : (byte?)Convert.ToByte(status)

            };


            Complaints = DataHelper.GetFilteredComplaints(filter);



        }

        string addToQStr(string name, string val, bool first = false)
        {
            string and = "&";
            if (first)
            {
                and = "";
            }

            if (val != null)
            {
                return and + name + "=" + val;
            }
            else
            {
                return "";
            }

        }

        protected void ButtonFilter_Click(object sender, EventArgs e)
        {
            string objectId = Request.Form["objectId"];
            string objectType = Request.Form["objectType"];
            string userSender = Request.Form["userSender"];
            string userRecipie = Request.Form["userRecipie"];
            string status = Request.Form["status"];

            string urlQuery = "?" + addToQStr("objectId", objectId, true);
            urlQuery += addToQStr("objectType", objectType);
            urlQuery += addToQStr("userSender", userSender);
            urlQuery += addToQStr("userRecipie", userRecipie);
            if (StructsHelper.ComplaintStatus.ContainsKey(status))
            {
                urlQuery += addToQStr("status", StructsHelper.ComplaintStatus[status].ToString());
            }
            


            Response.Redirect("ComplaintsPage.aspx" + urlQuery);


        }
    }
}