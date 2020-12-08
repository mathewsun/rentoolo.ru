using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class UserProfile : BasicPage
    {

        public Users AnotherUser;

        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];


            AnotherUser = DataHelper.GetUser(Guid.Parse(id));


        }
    }
}