using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class ChatCreationInfo
    {
        public Guid OwnerId { get; set; }
        public string ChatName { get; set; }
        public List<Guid> UserIds { get; set; }
    }
}