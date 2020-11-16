using System;
using System.Collections.Generic;
using System.Linq;
using Rentoolo.HelperModels;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Cabinet : BasicPage
    {
        public List<fnGetUserWallets_Result> UserWalletsList;

        public fnGetUserWallets_Result UserWalletRURT;

        public Users CurrentUser;

        public string[] AllCities = RusCities.AllRusCities;

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

        protected void ButtonCity_Click(object sender, EventArgs e)
        {
            string city = Request.Form["selectedCity"];

            DataHelper.SetUserCity(User, city);
        }

        protected void ButtonBirthDay_Click(object sender, EventArgs e)
        {
            string date = Request.Form["birthDay"];
            User.BirthDay = DateTime.Parse(date);
            DataHelper.SetUserBirthDay(User);
        }

        protected void ButtonSaveAvatar_Click(object sender, EventArgs e)
        {
            string data = Request.Form["avatarka"];

            var a = 4;

        }
    }
}