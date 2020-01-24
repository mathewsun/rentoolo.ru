using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Rentoolo.Model;
using Newtonsoft.Json;

namespace Rentoolo
{
    public partial class TokensCost : System.Web.UI.Page
    {
        public List<Model.TokensCost> tokensCosts;

        public string jsonTokensCosts;

        protected void Page_Load(object sender, EventArgs e)
        {
            tokensCosts = TokensDataHelper.GetTokensCosts();

            jsonTokensCosts = JsonConvert.SerializeObject(tokensCosts);
        }
    }
}