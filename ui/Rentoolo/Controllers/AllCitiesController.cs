using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Rentoolo.Model;

namespace Rentoolo.Controllers
{
    public class AllCitiesController : ApiController
    {
        // GET: top 10 DPD cities
        public IHttpActionResult Get(string text = null)
        {
            List<spDPDCitiesTop10_Result> top10cities = GeographyDPDHelper.GetDPDCitiesTop10(text);

            return Json(top10cities);
        }
    }
}
