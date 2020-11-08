using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class ItemLikeDislike
    {
        public string Type { get; set; }
        public int ObjectType { get; set; }
        public long ObjectId { get; set; }
        public Guid UserId { get; set; }
     
    }
}