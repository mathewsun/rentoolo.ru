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
using ObjectsComparer;
using Xunit;
using Comparer = ObjectsComparer.Comparer;

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
            var receivedRooms = _roomRepository.ReadRooms(createdRooms.Select(x=>x.Id).ToArray()).ToList();

            var comparer = new Comparer();
            comparer.AddComparerOverride("Id",DoNotCompareValueComparer.Instance);

            Xunit.Assert.Equal(createdRooms, receivedRooms/*, new ComparerWithoutId<Room>(comparer)*/);
            //Xunit.Assert.Collection(receivedRooms, x => Xunit.Assert.Equal(x,newRoom) );
            //Xunit.Assert.eq);
        }

    }

    public class ComparerWithoutId<T> : IEqualityComparer<T>
    {
        private Comparer _cmp;

        public ComparerWithoutId(Comparer cmp)
        {
            _cmp = cmp;
        }

        public bool Equals(T x, T y)
        {
            return _cmp.Compare(x, y);
        }

        public int GetHashCode(T obj)
        {
            throw new System.NotImplementedException();
        }
    }
}