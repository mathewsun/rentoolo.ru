using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class DPDCalcRequestModel
    {
        public string ClientKey { get; set; }
        public long ClientNumber { get; set; }
        public string DeliveryCityName { get; set; }
        public string PickupCityName { get; set; }
        public bool SelfPickup { get; set; }
        public bool SelfDelivery { get; set; }
        public double DeclaredValue { get; set; }
        public double Weight { get; set; }
    }
}