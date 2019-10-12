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
                Wallets item = dc.Wallets.Where(x => x.UserId == userId && x.CurrencyId == currencyId).FirstOrDefault();

                return item;
            }
        }

        public static int CreateUserWallet(Guid userId, int currencyId, float value)
        {
            using (var dc = new RentooloEntities())
            {
                Wallets item = new Wallets
                {
                    UserId = userId,
                    CurrencyId = currencyId,
                    Value = value,
                    CreateDate = DateTime.Now
                };

                var result = dc.Wallets.Add(item);

                var res = dc.SaveChanges();

                return result.Id;
            }
        }

        public static void UpdateUserWallet(Guid userId, int currencyId, float value)
        {
            using (var dc = new RentooloEntities())
            {
                Wallets item = dc.Wallets.Where(x => x.UserId == userId && x.CurrencyId == currencyId).FirstOrDefault();

                if (item == null)
                {
                    int walletId = CreateUserWallet(userId, currencyId, value);

                    item = dc.Wallets.Where(x => x.Id == walletId).FirstOrDefault();
                }
                else
                {
                    item.Value += value;

                    dc.SaveChanges();
                }
            }
        }
    }
}