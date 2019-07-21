using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class _Default : Page
    {
        public List<Rentoolo.Model.News> ListNews;

        public string UsercCount;

        public string UsersCountRegisteredToday;

        public string UsersCountOnline;

        public string FullDeposite;

        public string TodayDeposite;

        public string SafetyDeposite;

        public int RandomInt;

        protected void Page_Load(object sender, EventArgs e)
        {
            //Test();


            ListNews = DataHelper.GetActiveNewsLast5();

            if (!IsPostBack)
            {
                Random rnd = new Random();

                RandomInt = rnd.Next(-2, 2);

                UsercCount = DataHelper.GetSettingByName("UsersCount").Value;

                UsersCountRegisteredToday = DataHelper.GetSettingByName("UsersCountRegisteredToday").Value;

                UsersCountOnline = DataHelper.GetSettingByName("UsersCountOnline").Value;

                UsersCountOnline = (Convert.ToInt32(UsersCountOnline) + RandomInt).ToString();

            }
        }

        protected void Test()
        {
            //var terterte = DataHelper.GetEnteredCO();

            //PayPayMakeTransferClassTEst tetetet = new PayPayMakeTransferClassTEst();

            //List<PayPayMakeTransferClassTEst> list = new List<PayPayMakeTransferClassTEst>();

            //CashOuts item = DataHelper.GetCashOutForPayment();

            //if (item != null)
            //{
            //    tetetet.QRecepient = item.Number;
            //    tetetet.Value = item.Value;


            //    Rentoolo.Model.Phones acc = DataHelper.GetQiwiAcoountCashOut(item.Value);

            //    tetetet.Ql = acc.Number;
            //    tetetet.Qp = acc.Pwd;

            //    list.Add(tetetet);
            //}
        }

        public void LoginStatus1_LoggedOut(Object sender, System.EventArgs e)
        {
            Session.Remove("User");

            Response.Redirect("/");
        }
    }
}