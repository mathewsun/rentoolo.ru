using Newtonsoft.Json;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo
{
    public partial class CraftsManResume : System.Web.UI.Page
    {
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
            string country = String.Format("{0}", Request.Form["ctl00$MainContent$country"]);
            string region = String.Format("{0}", Request.Form["ctl00$MainContent$region"]);
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
                resume.ImgUrls = "[\"/img/a/noPhoto.png\"]";
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
            resume.Region = region;
            resume.Country = country;
            resume.Email = email;

            CraftsManDataHelper.AddCraftsMan(resume);

            Response.Redirect("CraftsManTasks.aspx");
        }

    }
}