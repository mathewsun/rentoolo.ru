using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.ChatFront
{
    public partial class ChatPage2 : BasicPage
    {
        public Users CurUser;

        protected void Page_Load(object sender, EventArgs e)
        {
            CurUser = User;
        }
    }
}