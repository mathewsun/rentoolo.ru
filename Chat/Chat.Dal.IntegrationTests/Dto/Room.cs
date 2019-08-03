using System;
using Chat.Dal.Dto;

namespace Chat.Dal.IntegrationTests.Dto
{
    public static class TestObjectBuilder
    {
        public static Chat.Dal.Dto.Room CreateRoom()
        {
            var res = new Room()
            {
                CreatedTime = new DateTime(2019, 8, 3),
                Name = "asp.net",
                Softdelete = false,
                
            };
            return res;
        }
    }
}