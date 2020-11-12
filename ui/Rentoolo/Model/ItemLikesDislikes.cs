using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public class ItemLikesDislikesQuery
    {
        public string Type { get; set; } = "like";
        public int ObjectType { get; set; }
        public long ObjectId { get; set; }
    }
}