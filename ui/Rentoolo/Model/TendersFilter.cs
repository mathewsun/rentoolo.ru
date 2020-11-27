using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class TendersFilter
    {


        public string Name { get; set; }
        public double? MinCost { get; set; }
        public double? MaxCost { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? Category { get; set; }
        public int? Mode { get; set; }



    }
}