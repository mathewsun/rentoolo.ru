using Chat.Dal.Dto;

namespace Chat.Dal.Repository
{
    public interface IMessageRepository
    {
        void CreateMessages(params Message[] messages);
        Message[] ReadMessages(params int[] userId);
        void UpdateMessages(params Message[] messages);
        void DeleteMessages(params int[] messageIds);
    }
}
