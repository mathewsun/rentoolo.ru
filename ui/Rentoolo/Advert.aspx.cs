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

        // user which created advert
        public Users AnotherUser;
        
        // advert id
        int advId;
        
        
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = Convert.ToInt64(Request.QueryString["id"]);
            advId = (int)id;

            if(id == 0)
            {
                Response.Redirect("/");
            }

            AdvertItem = AdvertsDataHelper.GetAdvert(id);
            CommentList = DataHelper.spGetCommentsForUser(User.UserId, advId);
            AnotherUser = DataHelper.GetUser(AdvertItem.CreatedUserId);

            if (!IsPostBack)
            {
                
                ViewsCount = DataHelper.GetUserViewsCount((int)id, StructsHelper.ViewedType["product"]);

                if (User != null)
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
        
        protected void RptrComments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }

        protected void RptrComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string cmdName = e.CommandName.ToString();
            string cmdArg = e.CommandArgument.ToString();
            int commentId = Convert.ToInt32(cmdArg);

            switch (cmdName)
            {
                case "Like":
                    DataHelper.LikeUnLike(User.UserId, commentId);
                    break;
                case "DisLike":
                    DataHelper.DisLikeUnDisLike(User.UserId, commentId);
                    break;
                default:
                    throw new Exception("unsopprted case");
                    break;
                
            }
        }


    }
}