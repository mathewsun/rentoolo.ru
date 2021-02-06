using Rentoolo.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rentoolo.Controllers.MVC
{
    public class DialogController : Controller
    {

        public ActionResult DialogRedirect(string userId1, string userId2)
        {
            Guid usrId1, usrId2;
            bool parsed1, parsed2;


            parsed1 = Guid.TryParse(userId1, out usrId1);
            parsed2 = Guid.TryParse(userId2, out usrId2);


            string query = "?userId1=" + userId1 + "&" + "userId2=" + userId2;





            if (parsed1 && parsed2)
            {

                //DataHelper.CreateChatDialog



                return Redirect("/ChatFront/ChatPage2.aspx" + query);
            }
            else
            {
                return Redirect("/404.aspx");
            }
            
        }






        






        // GET: Dialog/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Dialog/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Dialog/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Dialog/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Dialog/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Dialog/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Dialog/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
