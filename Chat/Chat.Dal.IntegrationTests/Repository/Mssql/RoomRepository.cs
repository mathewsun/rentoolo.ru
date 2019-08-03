using System.Linq;
using System.Reflection.Metadata.Ecma335;
using Chat.Dal.Dto;
using Chat.Dal.Repository;
using Chat.Dal.Repository.mssql;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace Chat.Dal.IntegrationTests.Repository.Mssql
{
    public class RoomRepositoryTest
    {
        public class TestContext
        {
            private readonly IRoomRepository _roomRepository;

            public TestContext(IRoomRepository roomRepository)
            {
                _roomRepository = roomRepository;
            }
        }

        private TestContext _testContext;
        private readonly IRoomRepository _roomRepository;
        private readonly ServiceProvider serviceProvider;


        public RoomRepositoryTest()
        {
            var collection = new ServiceCollection()
                //Entity Framework contexts cannot be shared by two threads
                //Entity Framework contexts are recommended to be Scoped
                .AddDbContext<ChattingContext>()
                .AddSingleton<IRoomRepository, RoomRepository>()
                //.AddSingleton<IRoomRepository, RoomRepository>(ctx => new RoomRepository()
                //    {Context = (ChattingContext) ctx.GetService(typeof(DbContext))})
                .AddSingleton< TestContext>()
                .AddSingleton<IMessageRepository, MessageRepository>();


            serviceProvider = collection.BuildServiceProvider();
            _roomRepository = serviceProvider.GetService<IRoomRepository>();
        }

        //public RoomRepositoryTest()
        //{
        //    _roomRepository = roomRepository; 
        //    //_roomRepository = serviceProvider.get <IRoomRepository>();
        //}

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