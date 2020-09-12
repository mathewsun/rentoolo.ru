using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.DatabaseHelpers
{
    public static class TendersHelper
    {

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




    }
}