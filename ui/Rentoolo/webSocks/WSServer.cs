using Fleck;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.webSocks
{
    public class WSServer
    {

        WebSocketServer fleckServer;


        public void Serve()
        {
            fleckServer = new WebSocketServer("ws://0.0.0.0:8080");
            fleckServer.Start(socket =>
            {
                socket.OnOpen = () => Console.WriteLine("Open!");
                socket.OnClose = () => Console.WriteLine("Close!");
                socket.OnMessage = message => socket.Send(message);
            });
        }



        



    }
}