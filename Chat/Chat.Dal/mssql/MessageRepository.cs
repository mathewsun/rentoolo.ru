using Chat.Dal.Dto;
using Chat.Dal.Repository;

namespace Chat.Dal.mssql
{
    public class MessageRepository:IMessageRepository
    {
        public void CreateMessages(params Message[] messages)
        {
            throw new System.NotImplementedException();
        }

        public Message[] ReadMessages(params int[] userId)
        {
            throw new System.NotImplementedException();
        }

        public void UpdateMessages(params Message[] messages)
        {
            throw new System.NotImplementedException();
        }

        public void DeleteMessages(params int[] messageIds)
        {
            throw new System.NotImplementedException();
        }
    }
}