using System.Collections.Generic;
using System.Linq;
using Chat.Dal.Repository;
using Chat.Dal.mssql;
using Chat.Dal.Dto;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Room.Dal.mssql
{
    public class RoomRepository : IRoomRepository
    {
        public ChattingContext Context { get; set; }

        public IEnumerable<EntityEntry<Chat.Dal.Dto.Room>> CreateRooms(params Chat.Dal.Dto.Room[] rooms)
        {
            foreach (var room in rooms)
            {
                var res = Context.Rooms.Add(room);
                yield return res;
            }
        }

        public List<Chat.Dal.Dto.Room> ReadRooms(int roomId)
        {
            return Context.Rooms.Where(x => x.Id == roomId).ToList();
        }

        public void UpdateRooms(params Chat.Dal.Dto.Room[] rooms)
        {
            Context.Rooms.UpdateRange(rooms);
        }

        public void DeleteRooms(params Chat.Dal.Dto.Room[] roomIds)
        {
            Context.Rooms.RemoveRange(roomIds);
        }
    }
}