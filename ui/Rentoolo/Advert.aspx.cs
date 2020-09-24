using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class Advert : BasicPage
    {
        public Adverts AdvertItem = new Adverts();
        public int ViewsCount = 0;
        public List<spGetCommentsForUser_Result> CommentList;
        
        // advert id
        int advId;

        // TODO: fix add UserViews add bug


        protected void Page_Load(object sender, EventArgs e)
        {
            long id = Convert.ToInt64(Request.QueryString["id"]);
            advId = (int)id;

            if(id == 0)
            {
                Response.Redirect("/");
            }

            // TODO: make tests
            CommentList = DataHelper.spGetCommentsForUser(User.UserId, advId);

            if (!IsPostBack)
            {

                ViewsCount = DataHelper.GetUserViewsCount((int)id, StructsHelper.ViewedType["product"]);

                if (User.UserId != null)
                {
                    // if user didnt authorised, it will be null 
                    UserViews userViews = new UserViews()
                    {
                        Date = DateTime.Now,
                        UserId = User.UserId,
                        Type = StructsHelper.ViewedType["product"],
                        ObjectId = (int)id
                    };

                    DataHelper.TryAddUserView(userViews);
                }




                RptrComments.DataSource = CommentList;
                RptrComments.DataBind();




                AdvertItem = AdvertsDataHelper.GetAdvert(id);

                if (User != null)
                {
                    WatchedDataHelper.AddWatched(User.UserId, id);
                }
                else
                {
                    if (Request.Cookies["uid"] != null)
                    {
                        string value = Request.Cookies["uid"].Value;

                        WatchedDataHelper.AddWatchedByCookies(value, id);
                    }
                }
                
            }

            string tempId = Page.RouteData.Values["id"] as string;
        }


        // add comment button
        protected void Button1_Click(object sender, EventArgs e)
        {
            string commentText = TextBoxComment.Text;
            var comment = new Comments()
            {
                Comment = commentText,
                UserId = User.UserId,
                UserName = User.UserName,
                Likes = 0,
                DisLikes = 0,
                Date = DateTime.Now,
                AdvertId = advId,
                Type = StructsHelper.ViewedType["product"]
            };

            DataHelper.AddComment(comment);



        }

        // TODO: add comments likes dislikes
        // TODO: test comments

        protected void ButtonLike_Click(object sender, CommandEventArgs e)
        {
            
            DataHelper.LikeUnLike(User.UserId, Convert.ToInt32(e.CommandArgument.ToString()));
            var name = nameof(ButtonLike_Click);
            Console.WriteLine(name);

        }

        protected void ButtonDisLike_Click(object sender, CommandEventArgs e)
        {

            Console.WriteLine(nameof(ButtonDisLike_Click));
        }

        protected void RptrComments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }

        protected void RptrComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

            DataHelper.LikeUnLike(User.UserId, Convert.ToInt32(e.CommandArgument.ToString()));

            var ca = e.CommandArgument.ToString();

            Console.WriteLine(e.CommandArgument.ToString());
        }
    }
}