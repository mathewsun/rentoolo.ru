using Rentoolo.Model;
using System;
using System.Collections.Generic;

namespace Rentoolo.Account
{
    public partial class MyRents : BasicPage
    {
        public List<RentForPage> ListItems; 
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ListItems = RentHelper.GetRent(User.UserId);
            }
        }
    }
}