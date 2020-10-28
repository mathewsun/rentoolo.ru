using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class ComplaintsPage : System.Web.UI.Page
    {
        public List<spGetComplaintsByRecipier_Result> Complaints;
        protected void Page_Load(object sender, EventArgs e)
        {

            // need add database function

            string userId = Request.QueryString["userId"];
            bool isRecipier = Convert.ToBoolean( Request.QueryString["isRecipier"]);

            

        }
    }
}