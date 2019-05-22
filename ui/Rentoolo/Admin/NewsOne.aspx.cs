using System;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class NewsOne : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int itemId = Convert.ToInt32(Request.Params["id"]);

                if (itemId != 0)
                {
                    Model.New item = DataHelper.GetOneNews(itemId);

                    TextBoxDate.Text = item.Date.ToString("dd.MM.yyyy");

                    NewsText.Text = item.Text;
                    // DataHelper.GetUser(DataHelper.GetBill(cashOut.BillId).UserId).UserName;

                    LabelChangesDate.Text = item.CreateDate.ToString("dd.MM.yyyy HH:mm");

                    LabelAuthor.Text = DataHelper.GetUser(item.AuthorId).UserName;

                    CheckBoxActive.Checked = item.Active.HasValue && item.Active.Value;
                }
                else
                {
                    LabelChangesDate.Text = DateTime.Now.ToString("dd.MM.yyyy");
                    LabelAuthor.Text = User.UserName;

                    CheckBoxActive.Checked = true;
                    TextBoxDate.Text = DateTime.Now.ToString("dd.MM.yyyy");
                }
            }
        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Model.New item = new Model.New();

            int itemId = 0;

            try
            {
                itemId = Convert.ToInt32(Request.Params["id"]);
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            if (itemId != 0)
            {
                item.Id = itemId;
            }

            try
            {
                var myDate = DateTime.ParseExact(TextBoxDate.Text, "dd.MM.yyyy", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None);

                myDate = myDate.AddHours(DateTime.Now.Hour);
                myDate = myDate.AddMinutes(DateTime.Now.Minute);
                myDate = myDate.AddSeconds(DateTime.Now.Second);

                item.Date = myDate;
                item.Text = NewsText.Text;
                item.CreateDate = DateTime.Now;
                item.AuthorId = User.UserId;
                item.Active = CheckBoxActive.Checked;

                DataHelper.SubmitNews(item);
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            Response.Redirect("News.aspx");
        }
    }
}