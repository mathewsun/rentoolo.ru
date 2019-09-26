using System;
using System.Collections.Generic;
using System.Linq;
using Chat.Dal.Dto;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.Repository.mssql
{
    public partial class RoomRepository
    {
        public List<Room> FindRooms(string name)
        {
            var rooms = _context.Rooms.AsNoTracking()
                .Where(r => string.Equals(r.Name, name, StringComparison.InvariantCultureIgnoreCase));
            return rooms.ToList();
        }
    }
}