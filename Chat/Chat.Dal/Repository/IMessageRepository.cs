using System.Collections.Generic;
using Chat.Dal.Dto;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.Repository
{
    public interface IMessageRepository
    {
        IEnumerable<EntityEntry<Message>> CreateMessages(params Message[] messages);
        List<Message> ReadMessages(int userId);
        void UpdateMessages(params Message[] messages);
        void DeleteMessages(params Message[] messageIds);
    }
}
