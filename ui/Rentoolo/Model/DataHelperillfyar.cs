using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class DataHelperillfyar
    {
        public static List<Newsillfyar> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.Newsillfyar.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}