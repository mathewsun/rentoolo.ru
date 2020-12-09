using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class RentForPage
    {
        public long Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Created { get; set; }
        public DateTime DateStart { get; set; }
        public DateTime DateEnd { get; set; }
        public int RentType { get; set; }
        public int DayRentPrice { get; set; }
        public int HourRentPrice { get; set; }
        public int MinuteRentPrice { get; set; }
        public string ImgUrls { get; set; }
    }
}