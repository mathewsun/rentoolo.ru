using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class TenderInfo : BasicPage
    {
        public Model.Tenders tender = new Model.Tenders();
        public string UserId;
        public string UserName;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                tender = TendersHelper.GetTenderById(Convert.ToInt32(Request.QueryString["id"]));

                var user = DataHelper.GetUser(tender.UserOwnerId);
                UserId = user.UserId.ToString();
                UserName = user.UserName;
                
                TextBoxCost.Text = "0";
            }
        }

        protected void ButtonAddRequest_Click(object sender, EventArgs e)
        {
            int cost = Convert.ToInt32(TextBoxCost.Text);
            string description = TextBoxDescription.Text;
            int tenderId = Convert.ToInt32(Request.QueryString["id"]);

            tender = TendersHelper.GetTenderById(tenderId);
            
            TenderRequest tenderRequest = new TenderRequest()
            {
                // ид текущего пользователя 
                ProviderId = User.UserId,
                // id владельца тендера
                CustomerId = tender.UserOwnerId,
                Description = description,
                Cost = cost,
                TenderId = tenderId,
                ProviderName = User.UserName

            };

            TendersHelper.CreateTenderRequest(tenderRequest);
            
        }
    }
}