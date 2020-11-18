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


            Image img; 

            using (var bs = new MemoryStream(buffer))
            {
                img = Image.FromStream(bs);
            }

            var f = File.Create("C:/Users/Necromant/Desktop/testssome.jpg");
            try
            {
                f.Write(buffer, 0, buffer.Length);
                f.Flush();
            }
            catch(Exception e)
            {
                var se = e.ToString();
            }
            
            f.Close();


            int pixLenOst = buffer.Length % 3;
            int pixelsLen = buffer.Length/3;

            byte[][] pixels = new byte[buffer.Length/3][];

            for (int i = 0; i < pixelsLen-pixLenOst; i++)
            {
                pixels[i] = new byte[3] { buffer[i*3], buffer[i*3+1], buffer[i*3+2] }; 
            }



            var bitmap = new Bitmap(file.Width, file.Height);

            for (int x = 0; x < file.Height; x++)
            {
                for (int y = 0; y<file.Width; y++)
                {
                    bitmap.SetPixel(y,x, Color.FromArgb(pixels[x + y][0], pixels[x + y][1], pixels[x + y][2]));
                }
            }

            img = Image.FromHbitmap(bitmap.GetHbitmap());
            var f2 = File.Create("C:/Users/Necromant/Desktop/tests/some2.jpg");

            img.Save(f2, System.Drawing.Imaging.ImageFormat.Jpeg);

            var size = img.Size;

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