using System;
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class WalletsHelper
    {
        public static List<fnGetUserWallets_Result> GetUserWallets(Guid userId)
        {
            using (var dc = new RentooloEntities())
            {
                List<fnGetUserWallets_Result> list = dc.fnGetUserWallets(userId).OrderByDescending(x=>x.Value).ToList();

                return list;
            }
        }
    }
}