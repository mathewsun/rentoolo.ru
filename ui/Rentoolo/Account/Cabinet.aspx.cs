using System;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Cabinet : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var ttt = User;

            if (!IsPostBack)
            {
                this.UpdateSession();

                Users user = DataHelper.GetUser(User.Id);
                
            }
        }
    }
}