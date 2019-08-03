using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.Repository.mssql
{
    public class RoomRepository : IRoomRepository
    {
        private readonly ChattingContext _context;

        public RoomRepository(ChattingContext context)
        {
            _context = context;
        }

        public IEnumerable<Chat.Dal.Dto.Room> CreateRooms(params Chat.Dal.Dto.Room[] rooms)
        {
            var res = new List<Chat.Dal.Dto.Room>();
            foreach (var room in rooms)
            {
                var temp = _context.Rooms.Add(room);
                res.Add(temp.Entity);
            }

            _context.SaveChanges();
            return res;
        }

        public List<Chat.Dal.Dto.Room> ReadRooms(params int[] ids)
        {
            var rooms = _context.Rooms.Where(r => ids.Contains(r.Id));
            return rooms.ToList();
        }

        public void UpdateRooms(params Chat.Dal.Dto.Room[] rooms)
        {
            _context.Rooms.UpdateRange(rooms);
            _context.SaveChanges();
        }

        public void DeleteRooms(params Chat.Dal.Dto.Room[] roomIds)
        {
            _context.Rooms.RemoveRange(roomIds);
            _context.SaveChanges();
        }
    }
}