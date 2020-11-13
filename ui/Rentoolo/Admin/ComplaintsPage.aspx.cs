using Rentoolo.Model;
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
            string status = Request.QueryString["userStatus"];

            Model.ComplaintsFilter filter = new ComplaintsFilter()
            {
                ObjectId = objectId == null ? null : (int?)Convert.ToInt32(objectId),
                ObjectType = objectType == null ? null : (int?)Convert.ToInt32(objectType),
                UserSender = userSender == null ? null : (Guid?)Guid.Parse(userSender),
                UserRecipier = userRecipie == null ? null : (Guid?)Guid.Parse(userRecipie),
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
            string objectId = Request.QueryString["objectId"];
            string objectType = Request.QueryString["objectType"];
            string userSender = Request.QueryString["userSender"];
            string userRecipie = Request.QueryString["userRecipie"];
            string status = Request.QueryString["status"];

            string urlQuery = "?" + addToQStr("objectId", objectId, true);
            urlQuery += addToQStr("objectType", objectType);
            urlQuery += addToQStr("userSender", userSender);
            urlQuery += addToQStr("userRecipie", userRecipie);
            urlQuery += addToQStr("status", status);


            Response.Redirect("ComplaintsPage.aspx" + urlQuery);


        }
    }
}