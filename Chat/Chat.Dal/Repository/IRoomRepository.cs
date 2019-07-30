using System.Collections.Generic;
using Chat.Dal.Dto;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.Repository
{
    public interface IRoomRepository
    {
        IEnumerable<EntityEntry<Dto.Room>> CreateRooms(params Dto.Room[] rooms);
        List<Dto.Room> ReadRooms(params int[] roomId);
        void UpdateRooms(params Dto.Room[] rooms);
        void DeleteRooms(params Dto.Room[] roomsIds);
    }
}