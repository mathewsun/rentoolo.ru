
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
                var list = ctx.NewsLateBloomer.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }
        public static void AddNews(NewsLateBloomer item)
        {
            using (var ctx = new RentooloEntities())
            {

                ctx.NewsLateBloomer.Add(item);
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