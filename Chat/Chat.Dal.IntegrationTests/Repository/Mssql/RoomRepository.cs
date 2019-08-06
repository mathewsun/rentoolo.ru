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
        public void CreateRooms_WhenNothingGetOnTheWay_RoomsCreated()
        {
            //a
            var newRoom = TestObjectBuilder.CreateMany<Room>(3).ToArray();
            //a
            var createdRooms = _roomRepository.CreateRooms(newRoom).ToList();
            //a
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x => x.Id).ToArray()).ToList();
            _roomRepository.DeleteRooms(createdRooms.Select(x => new Room { Id = x.Id }).ToArray());
            Xunit.Assert.Equal(createdRooms, receivedRooms);
        }

        [Fact]
        public void UpdateRooms_WhenRoomsExist_RoomsUpdated()
        {
            //a
            var newRoom = TestObjectBuilder.CreateMany<Room>(3).ToArray();
            var t1 = _roomRepository.Context.ChangeTracker.Entries().Count();
            var createdRooms = _roomRepository.CreateRooms(newRoom).ToArray();
            var t2 = _roomRepository.Context.ChangeTracker.Entries().Count();
            var updatedRooms = TestObjectBuilder.UpdateMany<Room>(100, createdRooms).ToArray();
            //a
            var t3 = _roomRepository.Context.ChangeTracker.Entries().Count();
            _roomRepository.UpdateRooms(updatedRooms);
            var t4 = _roomRepository.Context.ChangeTracker.Entries().Count();
            //a
            var t5 = _roomRepository.Context.ChangeTracker.Entries().Count();
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x => x.Id).ToArray()).ToArray();
            var t6 = _roomRepository.Context.ChangeTracker.Entries().Count();
            _roomRepository.DeleteRooms(createdRooms.Select(x => new Room { Id = x.Id }).ToArray());
            Xunit.Assert.Equal(updatedRooms, receivedRooms);
        }

        [Fact]
        public void DeleteRooms_WhenRoomsExist_RoomsDeleted()
        {
            //a
            var newRoom = TestObjectBuilder.CreateMany<Room>(3).ToArray();
            var createdRooms = _roomRepository.CreateRooms(newRoom).ToList();
            //a
            _roomRepository.DeleteRooms(createdRooms.Select(x => new Room { Id = x.Id }).ToArray());
            //a
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x => x.Id).ToArray()).ToList();
            Xunit.Assert.Empty(receivedRooms);
        }

    }
}