using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class DataHelperAezakmi
    {
        public static List<NewAezakmi> GetActiveNewsLast5()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewAezakmi.Where(x => x.Active && x.Active).OrderByDescending(x => x.Date).Take(5).ToList();

                return list;
            }

        }
        public static void AddNews(NewAezakmi item)
        {
            using (var ctx = new RentooloEntities())
            {

                ctx.NewAezakmi.Add(item);
                try
                {
                    ctx.SaveChanges();
                }
                catch (System.Exception ex)
                {
                    DataHelper.AddException(ex);
                }
            }
        }
    }
}
