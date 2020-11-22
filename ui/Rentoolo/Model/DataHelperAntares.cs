using System.Collections.Generic;
using System.Linq;


namespace Rentoolo.Model
{
    public static class DataHelperAntares
    {
        public static List<NewsAntares> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsAntares.Where(x => x.active).OrderByDescending(x => x.date).ToList();

                return list;
            }
        }
    }
}