using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.Account
{
    public partial class CaptchaUserControl : System.Web.UI.UserControl
    {
        public bool IsLocalhost { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            string host = HttpContext.Current.Request.Url.Host;

            if (host == "localhost")
            {
                IsLocalhost = true;
            }
            else
            {
                IsLocalhost = false;
            }
        }
    }
}