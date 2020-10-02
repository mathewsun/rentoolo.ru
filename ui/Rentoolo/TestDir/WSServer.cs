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
    public static class WSServer
    {
        static WebSocketServer server;

        // connected users at the moments to some chat
        static Dictionary<IWebSocketConnection, string> connectedUsers = new Dictionary<IWebSocketConnection, string>();
        static Dictionary<string, IWebSocketConnection> connectedUsersSockets = new Dictionary<string, IWebSocketConnection>();


        public static void SendMessageToUser(string userId, string data)
        {
            userId = userId.ToLower();
            connectedUsersSockets[userId].Send(data);
        }

        static void removeUser(IWebSocketConnection conn)
        {
            string userId = connectedUsers[conn];
            DataHelper.RemoveActiveWSUser(Guid.Parse(userId));
        }

        static void addUser(string userId, IWebSocketConnection conn)
        {
            userId = userId.ToLower();
            connectedUsers[conn] = userId;
            connectedUsersSockets[userId] = conn;
        }


        public static void Serve()
        {
            server = new WebSocketServer("ws://0.0.0.0:8080");
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
                            int dialogId = (int)json["dialogId"];
                            string strUserId = json["userId"].ToString();

                            addUser(strUserId, socket);



                            Guid userId = Guid.Parse(strUserId);



                            DataHelper.AddActiveWSUser(new DialogActiveUsers() { DialogId = dialogId, UserId = userId });

                            break;
                        case "message":

                            break;
                    }

                };
            });
        }


    }
}