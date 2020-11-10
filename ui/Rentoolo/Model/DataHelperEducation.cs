using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperEducation
    {
        public static List<NewsEducation> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsEducation.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
    }
}