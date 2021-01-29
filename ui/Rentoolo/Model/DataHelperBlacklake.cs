using System.Collections.Generic;
using System.Linq;


namespace Rentoolo.Model
{
    public static class DataHelperBlacklake
    {
        public static List<NewsEducationBlacklake> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsEducationBlacklake.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}