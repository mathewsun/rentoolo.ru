using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperGGdotNET
    {
        public static List<NewsGGdotNET> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsGGdotNET.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}