using System;
using System.Collections.Generic;
using System.Linq;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Cabinet : BasicPage
    {
        public List<fnGetUserWallets_Result> UserWalletsList;

        public fnGetUserWallets_Result UserWalletRURT;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.UpdateSession();

                Users user = DataHelper.GetUser(User.UserId);

                UserWalletsList = WalletsHelper.GetUserWallets(User.UserId);

                UserWalletRURT = UserWalletsList.Where(x => x.CurrencyId == 1).FirstOrDefault();
            }
        }
    }
}