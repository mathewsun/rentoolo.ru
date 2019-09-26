using Chat.Dal.Repository;
using Chat.Dal.Repository.mssql;
using Microsoft.Extensions.DependencyInjection;

namespace Chat.Dal.IntegrationTests.Repository.Mssql
{
    public class RepositoryTestBase
    {
        protected ServiceProvider ServiceProvider;

        public RepositoryTestBase()
        {
            var collection = new ServiceCollection()
                //Entity Framework contexts cannot be shared by two threads
                //Entity Framework contexts are recommended to be Scoped
                .AddDbContext<ChattingContext>()
                .AddSingleton<IRoomRepository, RoomRepository>()
                .AddSingleton<IMessageRepository, MessageRepository>();


            ServiceProvider = collection.BuildServiceProvider();
        }
    }
}