using Chat.Dal.Dto;
using Microsoft.EntityFrameworkCore;

namespace Chat.Dal.mssql
{
    public class ChattingContext : DbContext
    {
        public DbSet<Message> Messages { get; set; }
        public DbSet<Dto.Room> Rooms { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //optionsBuilder.UseSqlServer("Data Source=chattingdb");
            optionsBuilder.UseSqlServer("Server=DESKTOP-CAURBOF;Database=chattingdb;Trusted_Connection=True;");
        }
    }
}