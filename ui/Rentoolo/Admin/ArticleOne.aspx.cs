using System;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public partial class ArticleOne : BasicPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int itemId = Convert.ToInt32(Request.Params["id"]);

                if (itemId != 0)
                {
                    Model.Articles item = DataHelper.GetOneArticle(itemId);

                    TextBoxDate.Text = item.WhenDate.ToString("dd.MM.yyyy");

                    TextBoxHead.Text = item.Head;

                    NewsText.Text = item.Text;

                    LabelAuthor.Text = DataHelper.GetUser(item.UserId).UserName;
                }
                else
                {
                    LabelAuthor.Text = User.UserName;

                    TextBoxDate.Text = DateTime.Now.ToString("dd.MM.yyyy");
                }
            }
        }

        protected void ButtonSave_Click(object sender, EventArgs e)
        {
            Model.Articles item = new Model.Articles();

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

                item.WhenDate = myDate;
                item.Head = TextBoxHead.Text;
                item.Text = NewsText.Text;
                item.UserId = User.UserId;

                DataHelper.SubmitArticle(item);
            }
            catch (System.Exception ex)
            {
                DataHelper.AddException(ex);
            }

            Response.Redirect("Articles.aspx");
        }
    }
}