using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class AdvertsDataHelper
    {
        #region Объявления

        public static List<Adverts> GetAdverts()
        {
            using (var ctx = new DataClasses1DataContext())
            {
                var list = ctx.Adverts.OrderByDescending(x => x.CreateDate).ToList();

                return list;
            }
        }

        #endregion
    }
}