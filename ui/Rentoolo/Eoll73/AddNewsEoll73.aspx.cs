using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Eoll73
{
    public partial class AddNewsEoll73 : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Model.NewsEoll73 item = new Model.NewsEoll73();

            try
            {
                var publishDate = DateTime.ParseExact(TextBoxDate.Text, "dd.MM.yyyy", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None);

                publishDate = publishDate.AddHours(DateTime.Now.Hour);
                publishDate = publishDate.AddMinutes(DateTime.Now.Minute);
                publishDate = publishDate.AddSeconds(DateTime.Now.Second);

                item.Date = publishDate;
                item.Text = NewsText.Text;
                item.CreateDate = DateTime.Now;
                item.AuthorId = User.UserId;
                item.Active = CheckBoxActive.Checked;

                DataHelperEoll73.AddNews(item);
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            Response.Redirect("NewsEoll73.aspx");
        }
    }
}