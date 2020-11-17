using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rentoolo.Controllers
{
    public class AvatarsController : ApiController
    {
        public class AvatarInfo
        {
            public Guid UserId { get; set; }
        }

        public class AvatarFile
        {
            public Guid UserId { get; set; }
            public string FileName { get; set; }
            public string Buffer { get; set; }

            public int Width { get; set; }
            public int Height { get; set; }
        }


        // GET api/<controller>
        public IEnumerable<string> Get()
        {

            
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public string Get(Guid id)
        {
            


            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody] AvatarFile file)
        {
            string[] nums = file.Buffer.Trim().Split(',');
            byte[] buffer = new byte[nums.Length];

            for(int i = 0; i < nums.Length; i++)
            {
                buffer[i] = Convert.ToByte(nums[i]);
            }



            for(int  a = 0; a < 3; a++)
            {
                var s = 3;
            }

            Image img; 

            using (var bs = new MemoryStream(buffer))
            {
                img = Image.FromStream(bs);
            }

            var f = File.Create("some.jpg");

            f.Write(buffer, 0, buffer.Length);
            f.Close();


            


        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}