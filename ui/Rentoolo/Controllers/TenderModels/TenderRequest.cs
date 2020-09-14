using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Controllers.TenderModels
{
    public class TenderRequest
    {
        public string Description { get; set; }
        public string Cost { get; set; }
        public int TenderId { get; set; }
        public int UserOwnerId { get; set; }
    }
}