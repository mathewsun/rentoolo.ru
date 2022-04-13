
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperLateBloomer
    {
        public static List<NewsLateBloomer> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsLateBloomer.Where(x =>x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}