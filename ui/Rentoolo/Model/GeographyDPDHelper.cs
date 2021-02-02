using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class GeographyDPDHelper
    {
        public static List<spDPDCitiesTop10_Result> GetDPDCitiesTop10(string text)
        {
            using (var ctx = new RentooloEntities())
            {
                var list = ctx.spDPDCitiesTop10(text).ToList();

                return list;
            }
        }
    }
}