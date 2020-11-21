using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperShCodder
    {
        public static List<NewsShCodder> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsShCodder.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}