using System;
using System.Dynamic;
using System.Linq;
using Chat.Dal.Dto;
using Chat.Dal.Repository;

namespace Chat.Business
{
    public class ChattingService
    {
        private readonly IRoomRepository _roomRepository;
        private readonly IMessageRepository _messageRepository;

        public Room CreateRoom(int userId, string roomName)
        {
            var roomWithTheSameNameExists = _roomRepository.FindRooms(roomName).Any();
            if (roomWithTheSameNameExists)
            {
                return Room.CreateBlank();
            }

            var rooms = _roomRepository.CreateRooms(new Room()
                {Name = roomName, CreatedTime = DateTimeOffset.UtcNow, CreatorUserId = userId}).ToList();

            var roomCreated = rooms.Any();
            if (!roomCreated)
            {
                return Room.CreateBlank();
            }

            return rooms[0];
        }

        public bool SendMessage(int userSenderId, string message, int roomId)
        {
            if (string.IsNullOrWhiteSpace(message))
            {
                return false;
            }

            var rooms = _roomRepository.ReadRooms(roomId);
            var roomDoesntExists = rooms.Any();
            if (roomDoesntExists)
            {
                return false;
            }

            var messages = _messageRepository.CreateMessages(new Message(){RoomId = roomId,Text = message,UserId = userSenderId}).ToList();
            return messages[0].Entity;
        }
    }
}
