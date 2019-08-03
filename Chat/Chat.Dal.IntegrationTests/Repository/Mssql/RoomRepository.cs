using System.Linq;
using Chat.Dal.Dto;
using Chat.Dal.Repository;
using Xunit;

namespace Chat.Dal.IntegrationTests.Repository.Mssql
{
    public class RoomRepository
    {
        private IRoomRepository _roomRepository;

        public RoomRepository()
        {
            _roomRepository = new Dal.Repository.mssql.RoomRepository();
        }

        [Fact]
        public void CreateRooms()
        {
            //a
            var newRoom = new Room();
            //a
            var createdRooms = _roomRepository.CreateRooms(newRoom);
            //a
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x => x.Entity.Id).ToArray());
            Xunit.Assert.Collection(receivedRooms, x => Xunit.Assert.Equal(x,newRoom) );
        }
    }
}