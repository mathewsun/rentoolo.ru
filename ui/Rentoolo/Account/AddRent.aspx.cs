using Newtonsoft.Json;
using Rentoolo.Model;
using System;

namespace Rentoolo.Account
{
    public partial class AddRent : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonAddItem_Click(object sender, EventArgs e)
        {
            string title = String.Format("{0}", Request.Form["ctl00$MainContent$input_title"]);
            string description = String.Format("{0}", Request.Form["ctl00$MainContent$input_description"]);
            string minRentTime = String.Format("{0}", Request.Form["ctl00$MainContent$input_minrenttime"]);
            DateTime startDate = DateTime.Parse(input_dateofstart.Value);
            DateTime endDate = DateTime.Parse(input_dateofend.Value);
            int priceByDay = Convert.ToInt32(String.Format("{0}", Request.Form["ctl00$MainContent$input_pricebyday"]));
            int priceByHour = Convert.ToInt32(String.Format("{0}", Request.Form["ctl00$MainContent$input_pricebyhour"]));
            int priceByMinute = Convert.ToInt32(String.Format("{0}", Request.Form["ctl00$MainContent$input_pricebyminute"]));

            var objPhotos = Request.Form["RentPhotos"];

            Model.Rent rent = new Model.Rent();

            if (objPhotos != null)
            {
                String[] listPhotos = objPhotos.Split(',');

                var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

                rent.ImgUrls = jsonPhotos;
            }
            else
            {
                rent.ImgUrls = "[\"/img/a/noPhoto.png\"]";
            }

            rent.Title = title;
            rent.Description = description;
            rent.RentType = Convert.ToInt32(minRentTime);
            rent.DateStart = startDate;
            rent.DateEnd = endDate;
            rent.Created = DateTime.Now;
            rent.DayRentPrice = priceByDay;
            rent.HourRentPrice = priceByHour;
            rent.MinuteRentPrice = priceByMinute;
            rent.UserOwnerId = User.UserId;

            RentHelper.AddRent(rent);
        }
    }
}