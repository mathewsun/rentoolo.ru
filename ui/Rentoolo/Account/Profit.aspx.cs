using System;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Profit : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillList();

                LabelReferralLink.Text = string.Format("{0}/?refid={1}",
                    Request.Url.Scheme + System.Uri.SchemeDelimiter + Request.Url.Host,
                    User.PublicId);
            }
        }

        public void FillList()
        {

        }
    }
}