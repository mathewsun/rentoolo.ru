using System.Linq;
using System.Reflection.Metadata.Ecma335;
using Chat.Dal.Dto;
using Chat.Dal.Repository;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Chat.Dal.IntegrationTests.Dto;
using Xunit;

namespace Chat.Dal.IntegrationTests.Repository.Mssql
{
    public class RoomRepositoryTest : RepositoryTestBase
    {
        private readonly IRoomRepository _roomRepository;


        public RoomRepositoryTest()
        {
            _roomRepository = ServiceProvider.GetService<IRoomRepository>();
        }

        [Fact]
        public void CreateRooms()
        {
            //a
            var newRoom = TestObjectBuilder.CreateRoom();
            //a
            var createdRooms = _roomRepository.CreateRooms(newRoom);
            //a
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x => x.Entity.Id).ToArray());
            Xunit.Assert.Collection(receivedRooms, x => Xunit.Assert.Equal(x,newRoom) );
        }

    }
}