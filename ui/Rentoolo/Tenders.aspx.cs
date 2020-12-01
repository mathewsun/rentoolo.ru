using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;

namespace Rentoolo
{
    public partial class Tenders : System.Web.UI.Page
    {
        public List<Model.Tenders> TendersList;


        protected void Page_Load(object sender, EventArgs e)
        {

            var name = Request.QueryString["name"];
            var strMinCost = Request.QueryString["minCost"];
            var strMaxCost = Request.QueryString["maxCost"];
            var strStartDate = Request.QueryString["startDate"];
            var strEndDate = Request.QueryString["endDate"];
            var category = Convert.ToInt16(Request.QueryString["category"]);
            var mode = Convert.ToInt16(Request.QueryString["mode"]);

            double? minCost = null, maxCost = null;
            DateTime? startDate = null, endDate = null;

            if (strMinCost != null)
            {
                minCost = Convert.ToDouble(strMinCost);
            }

            if (strMaxCost != null)
            {
                maxCost = Convert.ToDouble(strMaxCost);
            }

            if (strStartDate != null)
            {
                startDate = DateTime.Parse(strStartDate);
            }

            if (strEndDate != null)
            {
                endDate = DateTime.Parse(strEndDate);
            }


            TendersFilter filter = new TendersFilter()
            {
                Name = name,
                MaxCost = maxCost,
                MinCost = minCost,
                StartDate = startDate,
                EndDate = endDate
            };

            TendersList = TendersHelper.GetTenders(filter);

        }





    }
}