using Newtonsoft.Json;
using Rentoolo.HelperModels;
using Rentoolo.Model;
using System;

namespace Rentoolo
{
    public partial class CraftsManResume : System.Web.UI.Page
    {
        public string[] AllCities = RusCities.AllRusCities;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonResume_Click(object sender, EventArgs e)
        {
            string craft = Request.Form["input_craft"];
            string description =Request.Form["input_description"];
            string price = Request.Form["input_price"];
            string phone = Request.Form["phone"];
            string firstName = Request.Form["input_firstName"];
            string lastName = Request.Form["input_lastName"];
            string address = Request.Form["address"];
            string email = Request.Form["email"];
            string city =  Request.Form["city"];
            
            var objPhotos = Request.Form["ResumePhotos"];

            Rentoolo.Model.CraftsMan resume = new Model.CraftsMan();

            if (objPhotos != null)
            {
                String[] listPhotos = objPhotos.Split(',');

                var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

                resume.ImgUrls = jsonPhotos;
            }
            else
            {
                resume.ImgUrls = "[\"/img/kitchen/falafel-s-ovoshami.jpg\"]";
            }

            try
            {
                resume.Price = double.Parse(price);
            }
            catch { }

            //resume.CreatedUserId = User.UserId;
            resume.Сraft = craft;
            resume.Created = DateTime.Now;
            resume.Address = address;
            resume.Description = description;
            resume.Phone = phone;
            resume.FirstName = firstName;
            resume.LastName = lastName;
            resume.Region = city; //TODO переделать поля в бд
            resume.Email = email;

            CraftsManDataHelper.AddCraftsMan(resume);

            Response.Redirect("CraftsManTasks.aspx");
        }

    }
}