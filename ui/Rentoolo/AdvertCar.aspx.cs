using Rentoolo.Model;
using Rentoolo.Model.HelperStructs;
using System;
namespace Rentoolo
{
    public partial class AdvertCar : BasicPage
    {
        public Adverts AdvertItem = new Adverts();
        public int ViewsCount = 0;

        public int ItemLikes = -1;
        public int ItemDislikes = -1;

        // user which created advert
        public Users AnotherUser;

        // advert id
        int advId;

        // you can see other types in StructsHelper
        int complaintType = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            long id = Convert.ToInt64(Request.QueryString["id"]);
            advId = (int)id;


            ItemLikes = DataHelper.GetItemLikes(0, advId);
            ItemDislikes = DataHelper.GetItemDisLikes(0, advId);




            if (id == 0)
            {
                Response.Redirect("/");
            }


            AdvertItem = AdvertsDataHelper.GetAdvert(id);
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
    }
}