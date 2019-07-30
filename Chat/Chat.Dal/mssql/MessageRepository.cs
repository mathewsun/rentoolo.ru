using System.Collections.Generic;
using System.Linq;
using Chat.Dal.Dto;
using Chat.Dal.Repository;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace Chat.Dal.mssql
{
    public class MessageRepository : IMessageRepository
    {
        public ChattingContext Context { get; set; }

        public IEnumerable<EntityEntry<Message>> CreateMessages(params Message[] messages)
        {
            foreach (var message in messages)
            {
                var res = Context.Messages.Add(message);
                yield return res;
            }
        }

        public List<Message> ReadMessages(int userId)
        {
            return Context.Messages.Where(x => x.UserId == userId).ToList();
        }

        public void UpdateMessages(params Message[] messages)
        {
            Context.Messages.UpdateRange(messages);
        }

        public void DeleteMessages(params Message[] messageIds)
        {
            Context.Messages.RemoveRange(messageIds);
        }
    }
}