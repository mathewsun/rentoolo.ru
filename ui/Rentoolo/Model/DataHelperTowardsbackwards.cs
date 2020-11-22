using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperTowardsbackwards
    {
        public static List<News_towardsbackwards> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.News_towardsbackwards.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}