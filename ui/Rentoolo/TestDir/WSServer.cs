using Fleck;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Rentoolo.Model;

namespace Rentoolo.TestDir
{


    // USE chatTest2.html 

    public static class WSServer
    {
        static WebSocketServer server;

        // connected users at the moments to some chat
        static Dictionary<IWebSocketConnection, string> connectedUsers = new Dictionary<IWebSocketConnection, string>();
        static Dictionary<string, IWebSocketConnection> connectedUsersSockets = new Dictionary<string, IWebSocketConnection>();


        public static void SendMessageToUser(string userId, string data)
        {
            
            connectedUsersSockets[userId].Send(data);
            // a55a7415-80e3-4dfd-92a1-3ea9d8d88329
            // a55a7415-80e3-4dfd-93a1-3ea9d8d88329
        }

        static void removeUser(IWebSocketConnection conn)
        {
            string userId = connectedUsers[conn];
            //DataHelper.RemoveActiveWSUser(Guid.Parse(userId));
            DataHelper.RemoveChatActiveWSUser(Guid.Parse(userId));
            connectedUsers.Remove(conn);
            connectedUsersSockets.Remove(userId);

        }

        static void addUser(string userId, IWebSocketConnection conn)
        {
            
            connectedUsers[conn] = userId;
            connectedUsersSockets[userId] = conn;
        }


        public static void Serve()
        {
            server = new WebSocketServer("ws://0.0.0.0:62434");
            server.Start(socket =>
            {
                
                socket.OnOpen = () => Console.WriteLine("Open!");
                socket.OnClose = () =>
                {
                    Console.WriteLine("Close!");
                    removeUser(socket);
                };
                socket.OnMessage = message =>
                {
                    JObject json = JObject.Parse(message);
                    string cmdType = json["type"].ToString();

                    switch (cmdType)
                    {
                        case "initUser":
                            int chatId = (int)json["chatId"];
                            string strUserId = json["userId"].ToString();

                            addUser(strUserId, socket);



                            Guid userId = Guid.Parse(strUserId);



                            //DataHelper.AddActiveWSUser(new DialogActiveUsers() { DialogId = chatId, UserId = userId });
                            DataHelper.AddActiveWSUser(new ChatActiveUsers() { ChatId = chatId, UserId = userId });

                            break;
                        case "message":

                            break;
                    }

                };
            });
        }


    }
}