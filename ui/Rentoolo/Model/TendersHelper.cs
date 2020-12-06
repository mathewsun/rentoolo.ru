using System;
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class TendersHelper
    {

        #region update

        public static void SetWinTenderRequest(int tRequestId)
        {
            using (var dc = new RentooloEntities())
            {
                dc.TenderRequest.First(x => x.Id == tRequestId).DateWin = DateTime.Now;
                dc.SaveChanges();
            }
        }



        public static void UpdateTReqStatusStart(int tRequestId)
        {
            using (var dc = new RentooloEntities())
            {
                var tRequest = dc.TenderRequest.First(x => x.Id == tRequestId);
                // tRequest.DateStart = DateTime.Now;
                tRequest.DateWin = DateTime.Now;

                dc.SaveChanges();
            }
        }

        public static void UpdateTReqStatusEnd(int tRequestId)
        {
            using (var dc = new RentooloEntities())
            {
                dc.TenderRequest.First(x => x.Id == tRequestId).DateStart = DateTime.Now;
                dc.SaveChanges();
            }
        }

        // with update, !! delete all tender requests
        public static void UpdateTReqStatusDelivered(int tRequestId, int tenderId)
        {
            using (var dc = new RentooloEntities())
            {
                dc.TenderRequest.First(x => x.Id == tRequestId).DateCompleted = DateTime.Now;

                var tRequests = dc.TenderRequest.Where(x => x.TenderId == tenderId);
                dc.TenderRequest.RemoveRange(tRequests);

                dc.SaveChanges();
            }
        }

        // used if customer didnt like tender which had done
        public static void UpdateTReqStatusDelDates(int tRequestId)
        {
            using (var dc = new RentooloEntities())
            {
                var tRequest = dc.TenderRequest.First(x => x.Id == tRequestId);
                tRequest.DateStart = null;
                tRequest.DateCompleted = null;
                tRequest.DateDelivered = null;
                dc.SaveChanges();
            }
        }

        public static void UpdateAllTenderFields(Tenders oldItem, Tenders newItem)
        {
            oldItem.Id = newItem.Id;
            oldItem.Name = newItem.Name;
            oldItem.Description = newItem.Description;
            oldItem.UserOwnerId = newItem.UserOwnerId;
            oldItem.Cost = newItem.Cost;
            oldItem.ImgUrls = newItem.ImgUrls;
            oldItem.Status = newItem.Status;
            oldItem.Created = newItem.Created;
            oldItem.CurrencyId = newItem.CurrencyId;
            oldItem.CategoryId = newItem.CategoryId;
        }


        public static void UpdateAllTender(Tenders tender, int oldTenderId)
        {
            using (var dc = new RentooloEntities())
            {
                Tenders oldTender = dc.Tenders.First(x => x.Id == oldTenderId);
                int oldId = oldTender.Id;
                UpdateAllTenderFields(oldTender, tender);
                oldTender.Id = oldId;
                dc.SaveChanges();
            }

        }




        #endregion

        #region create

        public static void CreateTender(Tenders tender)
        {
            using (var dc = new RentooloEntities())
            {
                dc.Tenders.Add(tender);
                dc.SaveChanges();
            }
        }

        public static void CreateTenderRequest(TenderRequest request)
        {
            using (var dc = new RentooloEntities())
            {
                dc.TenderRequest.Add(request);
                dc.SaveChanges();
            }
        }

        #endregion


        #region get


        public static TenderRequest GetWinedTRequest(int tenderId)
        {
            using (var dc = new RentooloEntities())
            {
                var tRequest = dc.TenderRequest.First(x => (x.TenderId == tenderId) && (x.DateWin != null));
                return tRequest;
            }
        }


        public static List<TenderRequest> GetUsersTRequests(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                // our user is a customer in TenderRequest entity
                var tRequests = dc.TenderRequest.Where(x => x.CustomerId == userId).ToList();
                return tRequests;
            }
        }


        public static TenderRequest GetTenderRequest(int id)
        {
            using (var dc = new RentooloEntities())
            {
                var tenderRequest = dc.TenderRequest.First(x => x.Id == id);
                return tenderRequest;
            }
        }

        public static List<Tenders> GetAllTenders()
        {
            using (var dc = new RentooloEntities())
            {
                List<Tenders> tenders = dc.Tenders.Select(x => x).ToList();
                return tenders;
            }
        }

        public static Tenders GetTenderById(int id)
        {
            using (var dc = new RentooloEntities())
            {

                Tenders tender = dc.Tenders.Where(x => x.Id == id).First();
                return tender;
            }
        }

        public static List<Tenders> GetTenders(string name)
        {
            using (var dc = new RentooloEntities())
            {
                var tenders = from t in dc.Tenders where t.Name.Contains(name) select t;
                return tenders.ToList();
            }
        }


        public static List<Tenders> GetTenders(TendersFilter filter)
        {
            using (var dc = new RentooloEntities())
            {
                var tenders = dc.Tenders.Select(x => x);

                if (filter.Name != null)
                {
                    tenders = tenders.Where(x => x.Name.Contains(filter.Name));
                }

                if (filter.MinCost != null)
                {
                    tenders = tenders.Where(x => x.Cost >= filter.MinCost);
                }

                if (filter.MaxCost != null)
                {
                    tenders = tenders.Where(x => x.Cost <= filter.MaxCost);
                }




                return tenders.ToList();
            }
        }


        public static List<Tenders> GetTenders(string name, int category)
        {
            using (var dc = new RentooloEntities())
            {
                var tenders = from t in dc.Tenders where t.Name.Contains(name) && t.CategoryId == category select t;
                return tenders.ToList();
            }
        }


        public static List<Tenders> GetTenders(string name, double minCost, double maxCost, int mode = 0)
        {
            //  mode(sort) 0- ascendance 1- descendance   - by cost

            using (var dc = new RentooloEntities())
            {
                IQueryable<Tenders> tenders = tendersByName(dc.Tenders, name);
                tenders = sortByCost(dc.Tenders, minCost, maxCost, mode);

                return tenders.ToList();
            }
        }

        public static List<Tenders> GetTenders(string name, DateTime startPeriod, DateTime endPeriod, int mode = 0)
        {
            //  mode(sort) 0- ascendance 1- descendance  

            using (var dc = new RentooloEntities())
            {
                IQueryable<Tenders> tenders = tendersByName(dc.Tenders, name);
                tenders = sortByDate(dc.Tenders, startPeriod, endPeriod, mode);

                return tenders.ToList();
            }
        }




        public static List<Tenders> GetTenders(string name, DateTime startPeriod, DateTime endPeriod, double minCost, double maxCost, int mode = 0)
        {
            //  mode(sort):  0- asc date asc cost 1- asc date desc cost 2- desc date ask cost 3- desc desc   
            // 1st always sort by cost

            using (var dc = new RentooloEntities())
            {
                IQueryable<Tenders> tenders = tendersByName(dc.Tenders, name);

                tenders = sortByCostAndDate(tenders, startPeriod, endPeriod, minCost, maxCost, mode);

                return tenders.ToList();
            }
        }


        public static List<Tenders> GetTenders(string name, DateTime startPeriod, DateTime endPeriod, double minCost, double maxCost, int category, int mode)
        {
            //  mode(sort) 0- ascendance 1- descendance  

            using (var dc = new RentooloEntities())
            {
                IQueryable<Tenders> tenders = tendersByName(dc.Tenders, name);

                tenders = sortByCostAndDate(tenders, startPeriod, endPeriod, minCost, maxCost, mode);
                tenders = sortByCategory(tenders, category);


                return tenders.ToList();
            }
        }



        public static List<Tenders> GetUsersTenders(Guid id)
        {
            using (var dc = new RentooloEntities())
            {
                var tenders = dc.Tenders.Where(x => x.UserOwnerId == id);
                return tenders.ToList();
            }
        }



        public static List<TenderRequest> GetTenderRequests(int id)
        {
            using (var dc = new RentooloEntities())
            {
                var trequests = dc.TenderRequest.Where(x => x.TenderId == id).ToList();
                return trequests;
            }
        }


        #endregion



        #region sort


        static IQueryable<Model.Tenders> tendersByName(IQueryable<Model.Tenders> tenders, string name)
        {
            return tenders.Where(x => x.Name.Contains(name));
        }


        static IQueryable<Model.Tenders> sortByCategory(IQueryable<Model.Tenders> tenders, int category)
        {
            return tenders.Where(x => x.CategoryId == category);
        }

        static IQueryable<Model.Tenders> sortByDate(IQueryable<Model.Tenders> tenders, DateTime startPeriod, DateTime endPeriod, int mode)
        {
            if (endPeriod < startPeriod)
            {
                tenders = (from t in tenders where (t.Created >= startPeriod) select t);
            }
            else
            {
                tenders = (from t in tenders where ((t.Created >= startPeriod) && (t.Created <= endPeriod)) select t);
            }

            if (mode == 0)
            {
                tenders = tenders.OrderBy(x => x.Created);
            }
            else
            {
                tenders = tenders.OrderByDescending(x => x.Created);
            }

            return tenders;
        }

        public static IQueryable<Model.Tenders> sortByCost(IQueryable<Model.Tenders> tenders, double minCost, double maxCost, int mode = 0)
        {
            //  mode(sort) 0- ascendance 1- descendance   - by cost

            if (maxCost < minCost)
            {
                tenders = (from t in tenders where (t.Cost >= minCost) select t);
            }
            else
            {
                tenders = (from t in tenders where ((t.Cost >= minCost) && (t.Cost <= maxCost)) select t);
            }

            if (mode == 0)
            {
                tenders = tenders.OrderBy(x => x.Cost);
            }
            else
            {
                tenders = tenders.OrderByDescending(x => x.Cost);
            }

            return tenders;
        }


        public static IQueryable<Model.Tenders> sortByCostAndDate(IQueryable<Model.Tenders> tenders, DateTime startPeriod, DateTime endPeriod, double minCost, double maxCost, int mode = 0)
        {
            //  mode(sort) 0- ascendance 1- descendance   - by cost

            if (mode == 0)
            {
                tenders = sortByCost(tenders, minCost, maxCost, 0);
                tenders = sortByDate(tenders, startPeriod, endPeriod, 0);
            }
            else if (mode == 1)
            {
                tenders = sortByCost(tenders, minCost, maxCost, 1);
                tenders = sortByDate(tenders, startPeriod, endPeriod, 0);
            }
            else if (mode == 2)
            {
                tenders = sortByCost(tenders, minCost, maxCost, 0);
                tenders = sortByDate(tenders, startPeriod, endPeriod, 1);
            }
            else
            {
                tenders = sortByCost(tenders, minCost, maxCost, 1);
                tenders = sortByDate(tenders, startPeriod, endPeriod, 1);
            }


            return tenders;
        }




        #endregion

    }
}