using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class DataHelperMrshkVV
    {
        public static List<NewsMrshkVV> GetActiveNews()
        {
            using (var db = new RentooloEntities())
            {
                return db.NewsMrshkVV.Where(n => n.Active).OrderByDescending(n => n.Date).ToList();
            }
        }
    }
}