using System;
using System.Collections.Generic;
using System.Linq;

namespace Rentoolo.Model
{
    public static class WalletsHelper
    {
        public static List<fnGetUserWalletsResult> GetUserWallets(Guid userId)
        {
            using (var dc = new DataClasses1DataContext())
            {
                List<fnGetUserWalletsResult> list = dc.fnGetUserWallets(userId).OrderByDescending(x=>x.Value).ToList();

                return list;
            }
        }

        public static void AddWalletForUser(Guid userId, int currencyId, double startBallance)
        {
            using (var dc = new DataClasses1DataContext())
            {
                dc.spAddWalletForUser(userId, currencyId, startBallance);
            }
        }
    }
}