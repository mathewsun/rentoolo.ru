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

        public Users CurrentUser;

        protected void Page_Load(object sender, EventArgs e)
        {


            string uniqueUserName = Request.Form["uniqueName"];
            if (uniqueUserName != null)
            {
                User.UniqueUserName = "@" + uniqueUserName;
                DataHelper.SetUserUniqueName(User);
            }


            if (!IsPostBack)
            {
                this.UpdateSession();

                Users user = DataHelper.GetUser(User.UserId);

                CurrentUser = user;

                UserWalletsList = WalletsHelper.GetUserWallets(User.UserId);

                UserWalletRURT = UserWalletsList.Where(x => x.CurrencyId == 1).FirstOrDefault();
            }

        }

        protected void ButtonSetUniqName_Click(object sender, EventArgs e)
        {
            //string uniqueUserName = Request.Form["uniqueName"];

            //CurrentUser.UniqueUserName = "@" + uniqueUserName;
            //DataHelper.UpdateUser(CurrentUser);

        }
    }
}