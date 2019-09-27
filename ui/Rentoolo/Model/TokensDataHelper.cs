using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class TokensDataHelper
    {
        public static void AddTokensBuying(TokensBuying item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.TokensBuying.Add(item);
                ctx.SaveChanges();
            }
        }

        public static List<TokensBuying> GetAllTokensBuying()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.TokensBuying.OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static List<TokensBuying> GetAllTokensBuyingByUser(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.TokensBuying.Where(x => x.UserId == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static void AddTokensSelling(TokensSelling item)
        {
            using (var ctx = new RentooloEntities())
            {
                ctx.TokensSelling.Add(item);
                ctx.SaveChanges();
            }
        }

        public static List<TokensSelling> GetAllTokensSelling()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.TokensSelling.OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }

        public static List<TokensSelling> GetAllTokensSellingByUser(Guid userId)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.TokensSelling.Where(x => x.UserId == userId).OrderByDescending(x => x.Id).ToList();
                return obj;
            }
        }
    }
}