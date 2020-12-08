using Newtonsoft.Json;
using Rentoolo.HelperModels;
using Rentoolo.Model;
using System;

namespace Rentoolo.CraftsMan
{
    public partial class CraftsManOrder : System.Web.UI.Page
    {
        public string[] AllCities = RusCities.AllRusCities;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonOrder_Click(object sender, EventArgs e)
        {

            string nameTask = Request.Form["input_nameTask"];
            string description = Request.Form["input_description"];
            string price = Request.Form["input_price"];
            string phone = Request.Form["phone"];
            string firstName = Request.Form["input_firstName"];
            string lastName = Request.Form["address"];
            string email = Request.Form["email"];
            string city = Request.Form["city"];
            string place = Request.Form["additem_place"];
            string address = Request.Form["address"];


            var objPhotos = Request.Form["OrderPhotos"];

            Rentoolo.Model.CraftsManOrder order = new Model.CraftsManOrder();

             if (objPhotos != null)
             {
                String[] listPhotos = objPhotos.Split(',');

                var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

                order.ImgUrls = jsonPhotos;
            }
            else
            {
                order.ImgUrls = "[\"/img/a/noPhoto.png\"]";
            }

            try
            {
                order.Price = double.Parse(price);
            }
            catch { }

            //order.video = video;

            //order.YouTubeUrl = video;

            //order.CreatedUserId = User.UserId;

            //order.Place = place;
            order.Created = DateTime.Now;
            order.Address = address;
            order.NameTask = nameTask;
            order.Description = description;
            order.Phone = phone;
            order.FirstName = firstName;
            order.LastName = lastName;
            order.Region = city; //TODO переделать поля в бд
            order.Email = email;

            CraftsManDataHelper.AddCraftsManOrder(order);

            Response.Redirect("CraftsManPage.aspx");
        }
    }
}