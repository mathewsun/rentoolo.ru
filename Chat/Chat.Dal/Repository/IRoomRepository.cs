using System.Collections.Generic;
using Chat.Dal.Dto;
using Chat.Dal.Repository.mssql;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.Repository
{
    public interface IRoomRepository
    {
        IEnumerable<Dto.Room> CreateRooms(params Dto.Room[] rooms);
        List<Dto.Room> ReadRooms(params int[] roomId);
        List<Dto.Room> FindRooms(string name);
        void UpdateRooms(params Dto.Room[] rooms);
        void DeleteRooms(params Dto.Room[] roomsIds);
    }
}