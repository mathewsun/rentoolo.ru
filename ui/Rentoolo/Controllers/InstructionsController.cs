using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class InstructionsController : ApiController
    {
        public IHttpActionResult Get()
        {
            List<Instruction> list = new List<Instruction>();

            list.Add(new Instruction
            {
                Id = 1,
                Name = "Как готовить солянку",
                YouTubeUrl = "https://www.youtube.com/watch?v=s5XvjAC7ai8"
            });

            list.Add(new Instruction
            {
                Id = 2,
                Name = "Готовим плов",
                YouTubeUrl = "https://www.youtube.com/watch?v=V83gbpm42yI"
            });

            list.Add(new Instruction
            {
                Id = 3,
                Name = "Оливье",
                YouTubeUrl = "https://www.youtube.com/watch?v=4lHQ1GejFvI"
            });

            return Json(list);
        }
    }
}
