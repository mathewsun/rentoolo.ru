using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Chat.Dal.Dto;
using Chat.Dal.Repository;

namespace Chat.Api
{
    public class ChatUserService
    {
        public IRoomRepository roomrepo { get; set; }
        public IMessageRepository roomrepo2 { get; set; }

        public void CreateChat(int ownerUserId, int userId, string name)
        {
            roomrepo.CreateRooms(new Room() {CreatorUserId = ownerUserId, Name = name, CreatedTime = DateTime.UtcNow});
        }

        //todo: add ransaction
        // todo: add migration
        public void SendMessageChat(int userId, int roomId, string text)
        {
            var rooms = roomrepo.ReadRooms(roomId);
            if (!rooms.Any())
            {
                throw new Exception("There is no room");
            }

            roomrepo2.CreateMessages(new Message(){CreatedTime = DateTime.UtcNow,RoomId = roomId,Text = text,UserId = userId});
        }
    }
}
