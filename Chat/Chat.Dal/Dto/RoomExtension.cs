namespace Chat.Dal.Dto
{
    public static class RoomExtension
    {
        public static bool IsBlank(this Room room)
        {
            return room.Id == Room.BlankId;
        }
    }
}