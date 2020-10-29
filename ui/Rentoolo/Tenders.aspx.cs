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

        public List<ViewedTender> ViewedTenders;

        protected void Page_Load(object sender, EventArgs e)
        {
            
            var name = Request.Form["name"];
            var strMinCost = Request.Form["minCost"];
            var strMaxCost = Request.Form["maxCost"];
            var strStartDate = Request.Form["startDate"];
            var strEndDate = Request.Form["endDate"];
            var category = Convert.ToInt16( Request.Form["category"]);
            var mode = Convert.ToInt16(Request.Form["mode"]);

            double minCost, maxCost;
            DateTime startDate, endDate;
            


            if (name != null && strMinCost != null && strStartDate != null && category != null)
            {
                minCost = Convert.ToDouble(strMinCost);
                maxCost = Convert.ToDouble(strMaxCost);
                startDate = DateTime.Parse(strStartDate);
                endDate = DateTime.Parse(strEndDate);

                TendersList = TendersHelper.GetTenders(name, startDate, endDate, minCost, maxCost, category, mode);
                
            }
            else if (name != null && strMinCost != null && strStartDate != null && category == null)
            {
                minCost = Convert.ToDouble(strMinCost);
                maxCost = Convert.ToDouble(strMaxCost);
                startDate = DateTime.Parse(strStartDate);
                endDate = DateTime.Parse(strEndDate);

                TendersList = TendersHelper.GetTenders(name, startDate, endDate, minCost, maxCost);
            }
            else if (name != null && strMinCost != null && strStartDate == null && category == null)
            {
                minCost = Convert.ToDouble(strMinCost);
                maxCost = Convert.ToDouble(strMaxCost);

                TendersList = TendersHelper.GetTenders(name,minCost, maxCost);
            }
            else if (name != null &&strStartDate != null && category == null)
            {
                startDate = DateTime.Parse(strStartDate);
                endDate = DateTime.Parse(strEndDate);

                TendersList = TendersHelper.GetTenders(name, startDate, endDate);
            }
            else if (name != null && category != null)
            {
                TendersList = TendersHelper.GetTenders(name, category);
            }
            else
            {
                TendersList = TendersHelper.GetAllTenders();
            }

            
            //TendersList = name == null ? TendersHelper.GetAllTenders() : TendersHelper.GetTenders(name);
            
        }
        

        public class ViewedTender
        {
            public Model.Tenders Tender;
            public Users User;
        }

    }
}