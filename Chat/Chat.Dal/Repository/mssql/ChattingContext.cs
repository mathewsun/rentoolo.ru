using Chat.Dal.Dto;
using Microsoft.EntityFrameworkCore;

namespace Chat.Dal.Repository.mssql
{
    public class ChattingContext : DbContext
    {
        public DbSet<Message> Messages { get; set; }
        public DbSet<Dto.Room> Rooms { get; set; }

        //protected ChattingContext()
        //{
        //    this.ChangeTracker.AutoDetectChangesEnabled = false;
        //}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //optionsBuilder.UseSqlServer("Data Source=chattingdb");
            optionsBuilder.UseSqlServer("Server=DESKTOP-CAURBOF;Database=chattingdb;Trusted_Connection=True;");
            optionsBuilder.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
            optionsBuilder.EnableSensitiveDataLogging();
        }
    }
}