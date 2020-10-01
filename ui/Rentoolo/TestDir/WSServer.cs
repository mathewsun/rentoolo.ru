using Fleck;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.TestDir
{
    public class WSServer
    {
        WebSocketServer server;

        public void Serve()
        {
            server = new WebSocketServer("ws://0.0.0.0:8080");
            server.Start(socket =>
            {
                socket.OnOpen = () => Console.WriteLine("Open!");
                socket.OnClose = () => Console.WriteLine("Close!");
                socket.OnMessage = message => socket.Send(message);
            });
        }


    }
}