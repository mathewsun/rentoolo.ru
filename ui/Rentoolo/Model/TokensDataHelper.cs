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

        public static List<spGetLast200TokensOperations_Result> GetLast200TokensOperations()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.spGetLast200TokensOperations().ToList();
                return obj;
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

        public static double GetOneTokensCost()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.spGetTokenCostToday().FirstOrDefault();

                return obj.Value;
            }
        }

        public static long GetFreeTokensCount()
        {
            Settings setting = DataHelper.GetSettingByName("FreeRentTokens");

            long todayCost = Convert.ToInt64(setting.Value);

            return todayCost;
        }

        public static long GetAvailableTokensCount()
        {
            Settings setting = DataHelper.GetSettingByName("AvailableTokensCount");

            long count = setting != null ? Int64.Parse(setting.Value) : 4900000000;

            return count;
        }

        public static void UpdateAvailableTokensCount(long value)
        {
            Settings setting = new Settings
            {
                Name = "AvailableTokensCount",
                Value = value.ToString()
            };

            DataHelper.UpdateSettingByName(setting);
        }

        public static List<TokensCost> GetTokensCosts()
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.TokensCost.Where(x => x.Date <= DateTime.Now).OrderBy(x => x.Date).ToList();
                return obj;
            }
        }
    }
}