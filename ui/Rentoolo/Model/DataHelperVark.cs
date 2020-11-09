using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class DataHelperVark
    {
        #region NewsVark

        public static List<NewsVark> GetNewsVark()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsVark.Where(x => x.Date <= DateTime.Now).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static List<NewsVark> GetActiveNewsVark()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsVark.Where(x => x.Active.HasValue && x.Active.Value).OrderByDescending(x => x.Date).ToList();

                return list;
            }
        }

        public static List<NewsVark> GetActiveNewsVarkLast5()
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.NewsVark.Where(x => x.Active.HasValue && x.Active.Value).OrderByDescending(x => x.Date).Take(5).ToList();

                return list;
            }
        }

        public static NewsVark GetOneNewsVark(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                var obj = ctx.NewsVark.FirstOrDefault(x => x.Id == id);
                return obj;
            }
        }

        public static void SubmitNewsVark(NewsVark item)
        {
            using (var ctx = new RentooloEntities())
            {
                if (item.Id == 0)
                {
                    ctx.NewsVark.Add(item);
                }
                else
                {
                    var obj = ctx.NewsVark.Single(x => x.Id == item.Id);
                    obj.Date = item.Date;
                    obj.Text = item.Text;
                    obj.CreateDate = item.CreateDate;
                    obj.AuthorId = item.AuthorId;
                    obj.Active = item.Active;
                }

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
        public static void DeleteNewsVark(int id)
        {
            using (var ctx = new RentooloEntities())
            {
                NewsVark obj = ctx.NewsVark.Single(x => x.Id == id);

                ctx.NewsVark.Remove(obj);

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

        #endregion
    }
}