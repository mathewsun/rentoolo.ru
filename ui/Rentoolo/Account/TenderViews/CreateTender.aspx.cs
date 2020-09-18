using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account.TenderViews
{
    public partial class CreateTender : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonAddTender_Click(object sender, EventArgs e)
        {
            string tname = TextBoxTName.Text;
            string description = TextBoxTDescription.Text;
            int cost = Convert.ToInt32(TextBoxTCost.Text);

            var tender = new Model.Tenders()
            {
               
                Name = tname,
                Description = description,
                Cost = cost,
                UserOwnerId = User.UserId,
                Created = DateTime.Now
            };

            TendersHelper.CreateTender(tender);

        }
    }
}