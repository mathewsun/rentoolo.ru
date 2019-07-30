using System;

namespace Chat.Dal.Dto
{
    public class Room
    {
        public int Id { get; set; }
        public int CreatorUserId { get; set; }
        public string Name { get; set; }
        public DateTime CreatedTime { get; set; }
        public bool Softdelete { get; set; }
    }
}