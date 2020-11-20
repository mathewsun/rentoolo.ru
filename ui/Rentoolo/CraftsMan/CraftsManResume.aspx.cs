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

            string craft = String.Format("{0}", Request.Form["MainContent$input_craft"]);
            string description = String.Format("{0}", Request.Form["MainContent$input_description"]);
            string price = String.Format("{0}", Request.Form["MainContent$price_value"]);
            string phone = String.Format("{0}", Request.Form["MainContent$resPhone"]);

            //TODO добавить в табл
            string firstName = String.Format("{0}", Request.Form["MainContent$input_firstName"]);
            string lastName = String.Format("{0}", Request.Form["MainContent$input_lastName"]);
            string address = String.Format("{0}", Request.Form["MainContent$address"]);
            string email = String.Format("{0}", Request.Form["MainContent$email"]);
            string country = String.Format("{0}", Request.Form["MainContent$country"]);
            string region = String.Format("{0}", Request.Form["MainContent$region"]);

            //var objPhotos = Request.Form[""];
            Rentoolo.Model.CraftsMan resume = new Model.CraftsMan();

            //if (objPhotos != null)
            //{
            //    String[] listPhotos = objPhotos.Split(',');

            //    var jsonPhotos = JsonConvert.SerializeObject(listPhotos);

            //    order.ImgUrls = jsonPhotos;
            //}
            //else
            //{
            //    order.ImgUrls = "[\"/img/a/noPhoto.png\"]";
            //}

            //try
            //{
            //    order.Category = Int32.Parse(category);
            //}
            //catch { } 
            try
            {
                resume.Price = double.Parse(price);
            }
            catch { }

            //resume.CreatedUserId = User.UserId;
            //resume.Craft
            resume.Created = DateTime.Now;
            resume.Address = address;
            resume.Description = description;
            resume.Phone = phone;
            CraftsManDataHelper.AddCraftsMan(resume);

            //Response.Redirect("");
        }

    }
}