using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class ComplaintsFilter 
    {
        public int? СomplaintType { get; set; }
        public int? ObjectId { get; set; }
        public int? ObjectType { get; set; }
        public System.Guid? UserSender { get; set; }
        public System.Guid? UserRecipier { get; set; }
        public System.DateTime? Data { get; set; }
        public Nullable<byte> Status { get; set; }
    }
}