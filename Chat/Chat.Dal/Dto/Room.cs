using System;

namespace Chat.Dal.Dto
{
    public class Room : IEquatable<Room>
    {
        public int Id { get; set; }
        public int CreatorUserId { get; set; }
        public string Name { get; set; }
        public DateTimeOffset CreatedTime { get; set; }
        public bool Softdelete { get; set; }

        public bool Equals(Room other)
        {
            if (ReferenceEquals(null, other)) return false;
            if (ReferenceEquals(this, other)) return true;
            return Id == other.Id
                   && CreatorUserId == other.CreatorUserId
                   && string.Equals(Name, other.Name)
                   && CreatedTime.Equals(other.CreatedTime)
                   && Softdelete == other.Softdelete;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((Room) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = Id;
                hashCode = (hashCode * 397) ^ CreatorUserId;
                hashCode = (hashCode * 397) ^ (Name != null ? Name.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ CreatedTime.GetHashCode();
                hashCode = (hashCode * 397) ^ Softdelete.GetHashCode();
                return hashCode;
            }
        }
    }
}