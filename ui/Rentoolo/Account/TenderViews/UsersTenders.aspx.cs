using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account.TenderViews
{
    public partial class UsersTenders : BasicPage
    {
        public List<Model.Tenders> Tenders;

        protected void Page_Load(object sender, EventArgs e)
        {
            

            if (!IsPostBack)
            {
                Tenders = TendersHelper.GetUsersTenders(User.UserId);
            }
        }
    }
}