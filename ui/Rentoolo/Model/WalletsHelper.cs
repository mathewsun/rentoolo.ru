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
                List<fnGetUserWallets_Result> list = dc.fnGetUserWallets(userId).OrderBy(x => x.CurrencyId).ToList();

                return list;
            }
        }

        public static Wallets GetUserWallet(Guid userId, int currencyId)
        {
            using (var dc = new RentooloEntities())
            {
                Wallets item = dc.Wallets.Where(x => x.UserId == userId && x.CurrencyId == x.CurrencyId).FirstOrDefault();

                return item;
            }
        }
    }
}