using Rentoolo.Model;
using Rentoolo.HelperModels;
using System;
using System.Collections.Generic;

namespace Rentoolo.CraftsMan
{
    public partial class CraftsManProfile : System.Web.UI.Page
    {
        public Rentoolo.Model.CraftsMan craftsMan;
       
        protected void Page_Load(object sender, EventArgs e)
        {
            string strId = Request.QueryString["Id"];

            int id = Convert.ToInt32(strId);
            craftsMan = CraftsManDataHelper.GetCraftsManById(id);
        }
    }
}