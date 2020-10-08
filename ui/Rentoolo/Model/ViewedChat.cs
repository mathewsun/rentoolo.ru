using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class ViewedChat
    {
        public string Type { get; set; }
        public long Id { get; set; }
        public string ChatName { get; set; }

        public ViewedChat(ViewedDialogInfo dInfo)
        {
            Type = "dialog";
            Id = dInfo.Id;
            ChatName = dInfo.DialogName;
            
        }


        public ViewedChat(Chats chatInfo)
        {
            Type = "chat";
            Id = chatInfo.Id;
            ChatName = chatInfo.ChatName;

        }



    }
}