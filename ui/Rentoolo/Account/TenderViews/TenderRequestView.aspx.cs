using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account.TenderViews
{
    public partial class TenderRequestView : System.Web.UI.Page
    {
        public TenderRequest TenderRequest;
        int id;
        // from tender id
        public int TenderId;

        // TODO: изменить статус у заявки при принятии ее от тендера

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                id = Convert.ToInt32(Request.QueryString["id"]);
                TenderId = Convert.ToInt32(Request.QueryString["tenderId"]);
                TenderRequest = TendersHelper.GetTenderRequest(id);
            }
        }

        protected void ButtonAccept_Click(object sender, EventArgs e)
        {
            TendersHelper.UpdateTReqStatusStart(id);



        }
    }
}