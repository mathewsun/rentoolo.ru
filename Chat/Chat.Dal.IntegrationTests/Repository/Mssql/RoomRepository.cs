using System.Collections;
using System.Collections.Generic;
//using System.Collections.Generic;
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
            var newRoom = TestObjectBuilder.CreateMany<Room>(3).ToArray();
            //a
            var createdRooms = _roomRepository.CreateRooms(newRoom).ToList();
            //a
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x => x.Id).ToArray()).ToList();

            Xunit.Assert.Equal(createdRooms, receivedRooms);
        }

    }
}