using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo.BatrebleSs
{
    public partial class AddNewsBatrebleSs : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void CheckBoxActive_CheckedChanged(object sender, EventArgs e)
        {

        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Model.NewsBatrebleSs item = new Model.NewsBatrebleSs();


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

                DataHelperBatrebleSs.AddNews(item);
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            Response.Redirect("NewsBatrebleSs.aspx");
        }
    }
}