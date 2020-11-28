using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperBatrebleSs
    {
        public static List<NewsBatrebleSs> GetActiveNews()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsBatrebleSs.Where(x => x.Active).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static void AddNews(NewsBatrebleSs item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.NewsBatrebleSs.Add(item);

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