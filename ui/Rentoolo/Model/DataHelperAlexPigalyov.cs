using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperAlexPigalyov
    {
        public static List<NewsAlexPigalyov> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsAlexPigalyov.Where(x => x.Active.Value).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}