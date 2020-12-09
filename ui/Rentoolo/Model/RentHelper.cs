using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class RentHelper
    {
        public static List<Rent> GetRequests(int auctionId)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Rent.Where(x => x.Id == auctionId);

                return result.ToList();
            }
        }


        public static void AddRentRequest(Rent auctionRequest)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Rent.Add(auctionRequest);
                ctx.SaveChanges();
            }
        }


        public static void UpdateAllRentFields(Rent oldItem, Rent newItem)
        {
            oldItem.Title = newItem.Title;
            oldItem.DayRentPrice = newItem.DayRentPrice;
            oldItem.HourRentPrice = newItem.HourRentPrice;
            oldItem.MinuteRentPrice = newItem.MinuteRentPrice;
            oldItem.ImgUrls = newItem.ImgUrls;
            oldItem.Description = newItem.Description;
            oldItem.DateEnd = newItem.DateEnd;
            oldItem.DateStart = newItem.DateStart;
        }


        public static void UpdateRent(Rent newItem, int oldItemId)
        {
            using (var ctx = new RentooloEntities())
            {
                var updatedItem = ctx.Rent.First(x => x.Id == oldItemId);
                UpdateAllRentFields(updatedItem, newItem);
                ctx.SaveChanges();
            }
        }



        public static int GetRentActiveCount()
        {
            using (var ctx = new RentooloEntities())
            {
                int count = ctx.Rent.Count();

                return count;
            }
        }

        public static Rent GetRent(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                return ctx.Rent.First(x => x.Id == id);
            }
        }

        public static List<RentForPage> GetRent(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Rent.Where(x => x.UserOwnerId == userId).ToList();

                List<RentForPage> list = new List<RentForPage>();

                foreach (var item in result)
                {
                    list.Add(new RentForPage
                    {
                        Id = item.Id,
                        Title = item.Title,
                        Created = item.Created,
                        DateEnd = (DateTime)item.DateEnd,
                        DateStart = item.DateStart,
                        MinuteRentPrice = (int)item.MinuteRentPrice,
                        HourRentPrice = (int)item.HourRentPrice,
                        DayRentPrice = item.DayRentPrice,
                        ImgUrls = item.ImgUrls
                    });
                }

                return list;
            }
        }
        public static long AddRent(Rent item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.Rent.Add(item);

                ctx.SaveChanges();

                return item.Id;
            }
        }

        public static List<Rent> GetAllRent()
        {
            using (var ctx = new RentooloEntities())
            {
                var result = ctx.Rent.ToList();

                return result;
            }
        }
    }
}