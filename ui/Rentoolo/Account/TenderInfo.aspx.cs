using Rentoolo.DatabaseHelpers;
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
        public Tenders tender = new Tenders();


        // TODO: id тендера хранится в url, можно данные из бд подтянуть будет

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                tender = TendersHelper.GetTenderById(Convert.ToInt32(Request.QueryString["id"]));

                
                TextBoxCost.Text = "0";
            }
        }

        protected void ButtonAddRequest_Click(object sender, EventArgs e)
        {
            int a = 10;

            string description = TextBoxDescription.Text;




            


        }
    }
}