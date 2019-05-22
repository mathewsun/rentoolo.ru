using System;
using System.Collections.Generic;
using Rentoolo.Model;

namespace Rentoolo.Account
{
    public partial class Referrals : BasicPage
    {
        public List<Model.Referrals> ListItemsFirstLevel;

        public List<Model.fnGetUserReferralsSecondLevelResult> ListItemsSecondLevel;

        public List<Model.fnGetUserReferralsThirdLevelResult> ListItemsThirdLevel;

        public int HoursDifference;

        public double ReferralsPercentFirstLevel;

        public double ReferralsPercentSecondLevel;

        public double ReferralsPercentThirdLevel;

        protected void Page_Load(object sender, EventArgs e)
        {
            //HoursDifference = Convert.ToInt32(DataHelper.GetSettingByName("HoursDifference").Value);

            ReferralsPercentFirstLevel = DataHelper.GetUserReferralsPercentFirstLevel();

            Double.TryParse(DataHelper.GetUserReferralsPercentSecondLevel(), out ReferralsPercentSecondLevel);

            Double.TryParse(DataHelper.GetUserReferralsPercentThirdLevel(), out ReferralsPercentThirdLevel);

            if (!IsPostBack)
            {
                ListItemsFirstLevel = DataHelper.GetUserReferrals(User.UserId);

                ListItemsSecondLevel = DataHelper.GetUserReferralsSecondLevel(User.UserId);

                ListItemsThirdLevel = DataHelper.GetUserReferralsThirdLevel(User.UserId);
            }
        }
    }
}