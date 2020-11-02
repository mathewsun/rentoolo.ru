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

        public bool? ByDate { get; set; }
        public bool? ByPrice { get; set; }
        public bool? ByDateDesc { get; set; }
        public bool? ByPriceDesc { get; set; }
        public string SortBy { get; set; } = "by date";
    }

}