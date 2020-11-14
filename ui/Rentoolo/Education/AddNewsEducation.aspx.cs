using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.Education
{
    public partial class AddNewsEducation : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Model.NewsEducation item = new Model.NewsEducation();

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

                DataHelperEducation.AddNews(item);
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            Response.Redirect("NewsEducation.aspx");
        }
    }
}