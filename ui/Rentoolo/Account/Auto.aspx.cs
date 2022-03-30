using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;
using Newtonsoft.Json;

namespace Rentoolo.Account
{
    public partial class Auto : BasicPage
    {
        public string CategoryId;

        protected void Page_Load(object sender, EventArgs e)
        {
            int i = 10;

            //CategoryId = Request.QueryString["cat"];

            //if (string.IsNullOrEmpty(CategoryId))
            //{
            //    Response.Redirect("/Account/Category");
            //}

            //CategoryName = CategoryHelper.GetCategoryName(CategoryId);
        }

        protected void ButtonAddItem_Click(object sender, EventArgs e)
        {
            string category = Request.QueryString["cat"];
            string name = String.Format("{0}", Request.Form["ctl00$MainContent$input_name"]);
            string description = String.Format("{0}", Request.Form["ctl00$MainContent$input_text"]);
            string price = String.Format("{0}", Request.Form["ctl00$MainContent$price_value"]);
            string video = String.Format("{0}", Request.Form["ctl00$MainContent$input_video"]);
            string place = String.Format("{0}", Request.Form["ctl00$MainContent$additem_place"]);
            string phone = String.Format("{0}", Request.Form["ctl00$MainContent$phonenum"]);
            string messageType = String.Format("{0}", Request.Form["ctl00$MainContent$contact"]);

            var objPhotos = Request.Form["AdvertPhotos"];

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