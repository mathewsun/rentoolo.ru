using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
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
        private Image cropImage(Image img, Rectangle cropArea)
        {
            Bitmap bmpImage = new Bitmap(img);
            return bmpImage.Clone(cropArea, bmpImage.PixelFormat);
        }

        private Image resizeImage(Image imgToResize, Size size)
        {
            return (Image)(new Bitmap(imgToResize, size));
        }
        public void Post([FromBody] AvatarFile file)
        {
            var projectDir = AppDomain.CurrentDomain.BaseDirectory.Replace('\\', '/');
            projectDir += "assets/img/avatars/";


            string[] nums = file.Buffer.Trim().Split(',');
            byte[] buffer = new byte[nums.Length];

            for (int i = 0; i < nums.Length; i++)
            {
                buffer[i] = Convert.ToByte(nums[i]);
            }


            Image img, croppedImg, resizedImg;

            using (var bs = new MemoryStream(buffer))
            {
                img = Image.FromStream(bs);

            }

            int hdelta = 0;
            int wdelta = 0;


            if (img.Width > img.Height)
            {
                wdelta = img.Width - img.Height;
            }
            else if (img.Width < img.Height)
            {
                hdelta = img.Height - img.Width;
            }


            var startPoint = new Point(wdelta / 2, hdelta / 2);
            var newImgSize = new Size(img.Width - wdelta, img.Height - hdelta);

            Rectangle cloneRect = new Rectangle(startPoint, newImgSize);


            croppedImg = cropImage(img, cloneRect);

            resizedImg = resizeImage(croppedImg, new Size(400, 400));


            using (var ms = new MemoryStream())
            {
                resizedImg.Save(ms, ImageFormat.Png);
                buffer = ms.ToArray();
            }


            var f = File.Create(projectDir + file.UserId.ToString() + ".png");
            try
            {
                f.Write(buffer, 0, buffer.Length);
                f.Flush();
            }
            catch (Exception e)
            {
                var se = e.ToString();

            }

            f.Close();
            f.Dispose();


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