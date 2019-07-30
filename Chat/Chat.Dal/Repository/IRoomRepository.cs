using Chat.Dal.Dto;

namespace Chat.Dal.Repository
{
    public interface IRoomRepository
    {
        void CreateRooms(params Room[] rooms);
        Message[] ReadRooms(params int[] roomId);
        void UpdateRooms(params Room[] rooms);
        void DeleteRooms(params int[] roomsIds);
    }
}