using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class AuctionsForPage
    {
        public long Id { get; set; }

        public System.DateTime Created { get; set; }

        public string Name { get; set; }

        public decimal StartPrice { get; set; }

    }
}