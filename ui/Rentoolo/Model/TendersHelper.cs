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
        public static void UpdateTReqStatusDelivered(int tRequestId,int tenderId)
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


        public static List<TenderRequest> GetUsersTRequests(int userId)
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
            using(var dc = new RentooloEntities())
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

        public static List<Tenders> GetUsersTenders(int id)
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


    }
}