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
            TendersList = name == null ? TendersHelper.GetAllTenders() : TendersHelper.GetTenders(name);

            //Guid[] userIds = TendersList.Select(x => x.UserOwnerId).ToArray();

            //var dc = new RentooloEntities();

            //var users = dc.Users.Where(x => userIds.Contains(x.UserId));

            //var result = from user in users
            //             join t in TendersList on user.UserId equals t.UserOwnerId
            //             select new ViewedTender() { Tender = t, User = user };

            //ViewedTenders = result.ToList();

            
        }


        public class ViewedTender
        {
            public Model.Tenders Tender;
            public Users User;
        }

    }
}