using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperVlad
    {
        public static List<NewsVlad> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsVlad.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static void AddNews(NewsVlad item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.NewsVlad.Add(item);
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