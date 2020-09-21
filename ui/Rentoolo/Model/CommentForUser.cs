using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class CommentForUser
    {

        public CommentForUser(Comments comment)
        {
            Id = comment.Id;
            UserId = comment.UserId;
            UserName = comment.UserName;
            AdvertId = comment.AdvertId;
            Comment = comment.Comment;
            Date = comment.Date;
            Type = comment.Type;

            Likes = DataHelper.LikesCount(comment.Id);
            DisLikes = DataHelper.DisLikesCount(comment.Id);
            HaveLike = DataHelper.HaveUserLike(comment.UserId, comment.Id);
            HaveDisLike = DataHelper.HaveUserDisLike(comment.UserId, comment.Id);


    }




        
            public int Id { get; set; }
            public System.Guid UserId { get; set; }
            public string UserName { get; set; }
            public int AdvertId { get; set; }
            public string Comment { get; set; }
            public System.DateTime Date { get; set; }
            public int Likes { get; set; }
            public int DisLikes { get; set; }
            public int Type { get; set; }
            public bool HaveLike { get; set; }
            public bool HaveDisLike { get; set; }
        


    }
}