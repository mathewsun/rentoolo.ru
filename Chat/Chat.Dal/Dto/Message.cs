using System;

namespace Chat.Dal.Dto
{
    public class Message
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int RoomId { get; set; }
        public string Text { get; set; }
        public DateTimeOffset CreatedTime{ get; set; }
        public bool Softdelete { get; set; }
    }
}