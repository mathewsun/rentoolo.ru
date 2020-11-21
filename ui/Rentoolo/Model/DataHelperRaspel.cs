using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperRaspel
    {
        public static List<NewsRaspel> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsRaspel.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}