using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class RatesDataHelper
    {
        public static List<Rates> GetRates()
        {
            using (var ctx = new RentooloEntities())
            {
                return ctx.Rates.ToList();
            }
        }

        public static void AddRates(Rates model)
        {
            using(var ctx = new RentooloEntities())
            {
                ctx.Rates.Add(model);
                ctx.SaveChanges();
            }
        }

        public static Rates GetLastRates()
        {
            using(var ctx = new RentooloEntities())
            {
                return ctx.Rates.OrderByDescending(item => item.Id).FirstOrDefault();
            }
        }
    }
}