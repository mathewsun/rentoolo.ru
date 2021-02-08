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
    public class LightUser
    {
        public string UserName { get; set; }
        public Guid UserId { get; set; }
    }
    public partial class ManageChat : BasicPage
    {
        public string GroupChats;
        public string DialogUsers;
        protected void Page_Load(object sender, EventArgs e)
        {
            
            var groupChats = DataHelper.GetOwnerChats(User.UserId);

            GroupChats = JsonConvert.SerializeObject(GroupChats);


            List<LightUser> lightUsers = new List<LightUser>();

            var users = DataHelper.GetDialogUsers(User.UserId);

            foreach(var user in users)
            {
                lightUsers.Add(new LightUser()
                {
                    UserId = user.UserId,
                    UserName = user.UserName
                });
            }


            DialogUsers = JsonConvert.SerializeObject(lightUsers);

        }
    }
}