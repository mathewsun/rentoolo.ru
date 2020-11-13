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
        // if tenderId != null 
        // that means that tender is modifying
        int? tenderId = null;
        public Model.Tenders CurrentTender = new Model.Tenders();
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["tenderId"];
            tenderId = id == null ? null : (int?)Convert.ToInt32(id);
            if (tenderId != null)
            {
                CurrentTender = TendersHelper.GetTenderById((int)tenderId);
            }
            

        }

        protected void ButtonAddTender_Click(object sender, EventArgs e)
        {
            //string tname = TextBoxTName.Text;
            //string description = TextBoxTDescription.Text;
            //int cost = Convert.ToInt32(TextBoxTCost.Text);


            string tname = Request.Form["tenderName"];
            string description = Request.Form["tenderDescription"];
            int cost = Convert.ToInt32(Request.Form["tenderCost"]);



            var tender = new Model.Tenders()
            {

                Name = tname,
                Description = description,
                Cost = cost,
                UserOwnerId = User.UserId,
                Created = DateTime.Now
            };

            if (tenderId != null)
            {
                Model.Tenders oldTender = TendersHelper.GetTenderById((int)tenderId);
                if (User.UserId == oldTender.UserOwnerId)
                {
                    TendersHelper.UpdateAllTender(tender, (int)tenderId);
                }

                DataHelper.AddOperation(new Model.Operations()
                {
                    UserId = User.UserId,
                    Type = (int)OperationTypesEnum.TenderUpdate,
                    WhenDate = DateTime.Now,
                    Comment = "",
                    Value = 0
                });

            }
            else
            {
                TendersHelper.CreateTender(tender);
                DataHelper.AddOperation(new Model.Operations()
                {
                    UserId = User.UserId,
                    Type = (int)OperationTypesEnum.TenderCreate,
                    WhenDate = DateTime.Now,
                    Comment = "",
                    Value = 0
                });
            }



        }
    }
}