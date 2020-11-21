using Newtonsoft.Json;
using Rentoolo.Model;
using System;

namespace Rentoolo.Account
{
    public partial class AddItemCar : BasicPage
    {
        public string CategoryId { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            CategoryId = Request.QueryString["cat"];

            if (string.IsNullOrEmpty(CategoryId))
            {
                Response.Redirect("/Account/Category");
            }

            //CategoryName = CategoryHelper.GetCategoryName(CategoryId);
        }

        protected void ButtonAddItem_Click(object sender, EventArgs e)
        {
            string category = Request.QueryString["cat"];
            //string name = String.Format("{0}", Request.Form["ctl00$MainContent$input_name"]);
            string description = String.Format("{0}", Request.Form["ctl00$MainContent$input_text"]);
            string price = String.Format("{0}", Request.Form["ctl00$MainContent$price_value"]);
            string video = String.Format("{0}", Request.Form["ctl00$MainContent$input_video"]);
            string place = String.Format("{0}", Request.Form["ctl00$MainContent$additem_place"]);
            string phone = String.Format("{0}", Request.Form["ctl00$MainContent$phonenum"]);
            string messageType = String.Format("{0}", Request.Form["ctl00$MainContent$contact"]);
            string vin = String.Format("{0}", Request.Form["ctl00$MainContent$input_vin"]);
            string color = String.Format("{0}", Request.Form["ctl00$MainContent$input_color"]);
            string brand = String.Format("{0}", Request.Form["ctl00$MainContent$input_brand"]);

            var objPhotos = Request.Form["AdvertPhotos"];

            string name = "Автомобиль " + brand;

            Rentoolo.Model.Adverts advert = new Model.Adverts();

            if (objPhotos != null)
            {
                String[] listPhotos = objPhotos.Split(',');

                var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

                advert.ImgUrls = jsonPhotos;
            }
            else
            {
                advert.ImgUrls = "[\"/img/a/noPhoto.png\"]";
            }

            try
            {
                advert.Category = Int32.Parse(category);
            }
            catch { }

            advert.Name = name;

            advert.Description = description;

            advert.Vin = vin;

            advert.Color = color;

            advert.Brand = brand;

            try
            {
                advert.Price = double.Parse(price);
            }
            catch { }

            //advert.video = video;

            advert.Address = place;

            advert.Phone = phone;

            advert.YouTubeUrl = video;

            advert.CreatedUserId = User.UserId;

            advert.Created = DateTime.Now;

            AdvertsDataHelper.AddAdvert(advert);

            Response.Redirect("MyAdverts.aspx");
        }

    }
}