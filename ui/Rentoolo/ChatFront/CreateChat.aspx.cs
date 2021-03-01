using Newtonsoft.Json;
using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Rentoolo.ChatFront
{
    public class DialogUser
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
    }
    public partial class CreateChat : BasicPage
    {
        public List<Users> DialogUsers;
        public string StrDU;
        protected void Page_Load(object sender, EventArgs e)
        {

            

            //DialogUsers = DataHelper.GetDialogUsers(User.UserId);

            

            //Dictionary<Guid, DialogUser> userDict = new Dictionary<Guid, DialogUser>();

            List<DialogUser> dialogUsers = new List<DialogUser>();

            foreach(var user in DialogUsers)
            {
                //userDict[user.UserId] = new DialogUser() { UserId = user.UserId, UserName = user.UserName };
                dialogUsers.Add(new DialogUser() { UserId = user.UserId, UserName = user.UserName });
            }

            StrDU = JsonConvert.SerializeObject(dialogUsers);

            var s = 3;
            //StrDU = JsonConvert.SerializeObject(userDict);


        }
    }
}