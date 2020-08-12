using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class InstructionController : ApiController
    {
        public IHttpActionResult Get(int id)
        {
            Instruction item = new Instruction
            {
                Id = 1,
                Name = "Как готовить солянку",
                YouTubeUrl = "https://www.youtube.com/watch?v=s5XvjAC7ai8"
            };

            return Json(item);
        }
    }

    public class Instruction
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string YouTubeUrl { get; set; }
        public string Category { get; set; }
    }
}
