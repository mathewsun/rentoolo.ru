using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class ItemLikesDislikesController : ApiController
    {

        



        // GET: api/ItemLikesDislikes
        public int Get([FromUri]ItemLikesDislikesQuery itemld)
        {
            int count;

            if (itemld.Type == "like")
            {
                count = DataHelper.GetItemLikes(itemld.ObjectType, itemld.ObjectId);
            }
            else
            {
                count = DataHelper.GetItemDisLikes(itemld.ObjectType, itemld.ObjectId);
            }

            return count;
        }

        // GET: api/ItemLikesDislikes/5
        public int Get(string id)
        {
            int count = -1;

            if (id == "like")
            {

            }
            else
            {

            }

            return 4;
        }

        // POST: api/ItemLikesDislikes
        public void Post([FromBody]ItemLikeDislike itemld)
        {
            if (itemld.Type == "like")
            {
                ItemLikes like = new ItemLikes()
                {
                    Date = DateTime.Now,
                    ObjectType = itemld.ObjectType,
                    ObjectId = itemld.ObjectId,
                    UserId = itemld.UserId
                };

                DataHelper.LikeItem(like);

            }
            else
            {
                ItemDislikes dislike = new ItemDislikes()
                {
                    Date = DateTime.Now,
                    ObjectType = itemld.ObjectType,
                    ObjectId = itemld.ObjectId,
                    UserId = itemld.UserId
                };
                DataHelper.DisLikeItem(dislike);
            }
            
        }

        // PUT: api/ItemLikesDislikes/5
        public void Put(int id, [FromBody]string value)
        {

        }

        // DELETE: api/ItemLikesDislikes/5
        public void Delete(int id)
        {
        }
    }
}
