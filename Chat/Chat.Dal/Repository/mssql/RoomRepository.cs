using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.Repository.mssql
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

        public List<Chat.Dal.Dto.Room> ReadRooms(params int[] creatorUserId)
        {
            var rooms = Context.Rooms.Where(r => creatorUserId.Contains(r.CreatorUserId));
            return rooms.ToList();
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