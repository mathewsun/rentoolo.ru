using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.CraftsMan
{
    public partial class CraftsManOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void ButtonOrder_Click(object sender, EventArgs e)
        {

            string nameTask = String.Format("{0}", Request.Form["MainContent$input_nameTask"]);
            string description = String.Format("{0}", Request.Form["MainContent$input_description"]);
            string price = String.Format("{0}", Request.Form["MainContent$input_price"]);
            string phone = String.Format("{0}", Request.Form["MainContent$phone"]);
            string firstName = String.Format("{0}", Request.Form["MainContent$input_firstName"]);
            string lastName = String.Format("{0}", Request.Form["MainContent$input_lastName"]);
            string address = String.Format("{0}", Request.Form["MainContent$address"]);
            string email = String.Format("{0}", Request.Form["MainContent$email"]);
            string country = String.Format("{0}", Request.Form["MainContent$country"]);
            string region = String.Format("{0}", Request.Form["MainContent$region"]);

            //var objPhotos = Request.Form[""];



            Rentoolo.Model.CraftsManOrder order = new Model.CraftsManOrder();

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
                order.Price = double.Parse(price);
            }
            catch { }

            //order.video = video;

            //order.YouTubeUrl = video;

            //order.CreatedUserId = User.UserId;

            order.Created = DateTime.Now;
            order.Address = address;
            order.NameTask = nameTask;
            order.Description = description;
            order.Phone = phone;
            order.FirstName = firstName;
            order.LastName = lastName;
            order.Region = region;
            order.Country = country;

            CraftsManDataHelper.AddCraftsManOrder(order);

            //Response.Redirect("");
        }
    }
}