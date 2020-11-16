using System;

namespace Rentoolo.Model
{
    public class SellFilter
    {
        public string Search { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public static DateTime DefaultDate = DateTime.Parse("01-01-0001 00:00:00");

        public bool OnlyInName { get; set; }

        public decimal? StartPrice { get; set; }
        public decimal? EndPrice { get; set; }

        public string City { get; set; }

        public string SortBy { get; set; } = "date";
    }

    public class StrSellFilter
    {
        public string Search { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public bool OnlyInName { get; set; }

        public decimal? StartPrice { get; set; }
        public decimal? EndPrice { get; set; }

        public string City { get; set; }

        public string SortBy { get; set; } = "date";


        public void SetFilterValues(SellFilter search)
        {
            StrSellFilter filter = this;

            filter.Search = search.Search;
            filter.StartDate = search.StartDate;
            filter.EndDate = search.EndDate;
            filter.OnlyInName = (bool)search.OnlyInName == null ? false : (bool)search.OnlyInName;
            filter.StartPrice = search.StartPrice;
            filter.EndPrice = search.EndPrice;
            filter.City = search.City;
            filter.SortBy = search.SortBy;

        }



    }


}