using Microsoft.EntityFrameworkCore.Migrations;

namespace Chat.Dal.Migrations
{
    public partial class RoomFieldAdded : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "CreatorUserId",
                table: "Rooms",
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CreatorUserId",
                table: "Rooms");
        }
    }
}
