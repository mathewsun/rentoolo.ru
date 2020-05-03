namespace Rentoolo.Model
{
    public class QiwiPayment
    {
        public string Login { get; set; }

        public string Pwd { get; set; }

        public double Amount { get; set; }

        public string Recipient { get; set; }

        public string Comment { get; set; }
    }
}