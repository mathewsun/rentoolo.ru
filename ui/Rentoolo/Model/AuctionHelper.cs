using System;
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class AuctionsHelper
    {


        public static List<AuctionRequests> GetRequests(int auctionId)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.AuctionRequests.Where(x => x.AuctionId == auctionId);

                return result.ToList();
            }
        }


        public static void AddAuctionRequest(AuctionRequests auctionRequest)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.AuctionRequests.Add(auctionRequest);
                ctx.SaveChanges();
            }
        }


        public static void UpdateAllAuctionFields(Auctions oldItem, Auctions newItem)
        {
            oldItem.Name = newItem.Name;
            oldItem.StartPrice = newItem.StartPrice;
            oldItem.ImgUrls = newItem.ImgUrls;
            oldItem.Description = newItem.Description;
            oldItem.DataEnd = newItem.DataEnd;
        }


        public static void UpdateAuction(Auctions newItem,int oldItemId)
        {
            using (var ctx = new RentooloEntities())
            {
                var updatedItem = ctx.Auctions.First(x=>x.Id==oldItemId);
                UpdateAllAuctionFields(updatedItem, newItem);
                ctx.SaveChanges();
            }
        }



        public static int GetAuctionsActiveCount()
        {
            using (var ctx = new RentooloEntities())
            {
                int count = ctx.Auctions.Count();

                return count;
            }
        }



        public static Auctions GetAuction(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                return ctx.Auctions.First(x => x.Id == id);
            }
        }




        public static List<AuctionsForPage> GetAuctions(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Auctions.Where(x => x.UserId == userId).ToList();

                List<AuctionsForPage> list = new List<AuctionsForPage>();

                foreach (var item in result)
                {
                    list.Add(new AuctionsForPage
                    {
                        Id = item.Id,
                        Name = item.Name,
                        Created = item.Created,
                        StartPrice = item.StartPrice,
                        ImgUrls = item.ImgUrls
                    });
                }

                return list;
            }
        }

        public static int AddAuction(Auctions item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Auctions.Add(item);

                ctx.SaveChanges();

                return item.Id;
            }
        }

        public static List<Auctions> GetAllAuctions()
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Auctions.ToList();

                return result;
            }
        }

    }
}
