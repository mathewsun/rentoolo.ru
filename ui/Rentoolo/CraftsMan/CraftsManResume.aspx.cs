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
            string craft = String.Format("{0}", Request.Form["ctl00$MainContent$input_craft"]);
            string description = String.Format("{0}", Request.Form["ctl00$MainContent$input_description"]);
            string price = String.Format("{0}", Request.Form["ctl00$MainContent$input_price"]);
            string phone = String.Format("{0}", Request.Form["ctl00$MainContent$phone"]);
            string firstName = String.Format("{0}", Request.Form["ctl00$MainContent$input_firstName"]);
            string lastName = String.Format("{0}", Request.Form["ctl00$MainContent$input_lastName"]);
            string address = String.Format("{0}", Request.Form["ctl00$MainContent$address"]);
            string email = String.Format("{0}", Request.Form["ctl00$MainContent$email"]);
            string city = String.Format("{0}", Request.Form["ctl00$MainContent$city"]);
            
            var objPhotos = String.Format("{0}", Request.Form["ResumePhotos"]);

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
                int category = 1;
                resume.Category = category;

                resume.Id = category;  // TODO переделать
            }
            catch { }
            try
            {
                resume.Price = float.Parse(price);
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