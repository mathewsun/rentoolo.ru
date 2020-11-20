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
        private Image cropImage(Image img, Rectangle cropArea)
        {
            Bitmap bmpImage = new Bitmap(img);
            return bmpImage.Clone(cropArea, bmpImage.PixelFormat);
        }
        public void Post([FromBody] AvatarFile file)
        {
            var projectDir = AppDomain.CurrentDomain.BaseDirectory.Replace('\\', '/');
            projectDir += "assets/img/avatars/";

            int weidth = 400;
            int height = 400;


            string[] nums = file.Buffer.Trim().Split(',');
            byte[] buffer = new byte[nums.Length];

            for (int i = 0; i < nums.Length; i++)
            {
                buffer[i] = Convert.ToByte(nums[i]);
            }


            Image img, img2;

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


            img2 = cropImage(img, cloneRect);


            using (var ms = new MemoryStream())
            {
                img2.Save(ms, ImageFormat.Png);
                buffer = ms.ToArray();

            }


            //using (var bs = new MemoryStream(buffer))
            //{
            //    img2 = Image.FromStream(bs);

            //}



            //int hdelta = 0;
            //int wdelta = 0;

            //if (img.Width > img.Height)
            //{
            //    wdelta = img.Width - img.Height;
            //}
            //else if (img.Width < img.Height)
            //{
            //    hdelta = img.Height - img.Width;
            //}


            //var startPoint = new Point( wdelta / 2,  hdelta / 2);
            //var newImgSize = new Size(img.Width - wdelta, img.Height - hdelta);

            //Bitmap fromImgBitmap = img as Bitmap;

            //var imgBitmap = new Bitmap(img.Width - wdelta, img.Height - hdelta);

            //var r = new Rectangle(startPoint, newImgSize);

            //Graphics g = Graphics.FromImage((Image)imgBitmap);

            //g.DrawImage(img, img.Width - wdelta / 2, img.Height - hdelta / 2, img.Width - wdelta, img.Height - hdelta);



            //img = imgBitmap as Image;

            //for (int x = startPoint.X; x < newImgSize.Width; x++)
            //{
            //    for (int y = startPoint.Y; y < newImgSize.Height; y++)
            //    {
            //        var color = fromImgBitmap.GetPixel(startPoint.X + x, startPoint.Y + y);
            //        imgBitmap.SetPixel(x, y, color);
            //    }
            //}








            //using (var ms = new MemoryStream())
            //{
            //    img.Save(ms, ImageFormat.Png);
            //    buffer = ms.ToArray();
            //}

            //using (var ms = new MemoryStream())
            //{
            //    imgBitmap.Save(ms, ImageFormat.Png);
            //    buffer = ms.ToArray();
            //}



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

            //int pixLenOst = buffer.Length % 3;
            //int pixelsLen = buffer.Length/3;

            //byte[][] pixels = new byte[buffer.Length/3][];

            //for (int i = 0; i < pixelsLen-pixLenOst; i++)
            //{
            //    pixels[i] = new byte[3] { buffer[i*3], buffer[i*3+1], buffer[i*3+2] }; 
            //}

            //var bitmap = new Bitmap(file.Width, file.Height);

            //for (int x = 0; x < file.Height; x++)
            //{
            //    for (int y = 0; y<file.Width; y++)
            //    {
            //        bitmap.SetPixel(y,x, Color.FromArgb(pixels[x + y][0], pixels[x + y][1], pixels[x + y][2]));
            //    }
            //}

            //img = Image.FromHbitmap(bitmap.GetHbitmap());
            //var f2 = File.Create("C:/Users/Necromant/Desktop/tests/some.jpg");

            //img.Save(f2, System.Drawing.Imaging.ImageFormat.Jpeg);

            //f2.Flush();
            //f2.Close();

            //var size = img.Size;

        }


        void cropImage(Image img,int x, int y, int weight, int height)
        {

            Rectangle cropRect = new Rectangle(x,y,weight,height);
            Bitmap src = img as Bitmap;
            Bitmap target = new Bitmap(cropRect.Width, cropRect.Height);

            using (Graphics g = Graphics.FromImage(target))
            {
                g.DrawImage(src, new Rectangle(0, 0, target.Width, target.Height),
                                 cropRect,
                                 GraphicsUnit.Pixel);

                
            }




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