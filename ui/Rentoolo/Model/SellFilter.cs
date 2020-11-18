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
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string OnlyInName { get; set; }
        public string StartPrice { get; set; }
        public string EndPrice { get; set; }
        public string City { get; set; }
        public string SortBy { get; set; }


        public void SetFilterValues(SellFilter search)
        {
            this.Search = search.Search;
            this.StartDate = search.StartDate == null ? "" : search.StartDate.ToString();
            this.EndDate = search.EndDate == null ? "" : search.EndDate.ToString();
            this.OnlyInName = (bool)search.OnlyInName == null ? "" : search.OnlyInName == true ? "on" : "";
            this.StartPrice = search.StartPrice == null ? "" : search.StartPrice.ToString();
            this.EndPrice = search.EndPrice == null ? "" : search.StartPrice.ToString();
            this.City = search.City;
            this.SortBy = search.SortBy;
        }

    }


}