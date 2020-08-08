using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Rentoolo.Controllers.KitchenModel;
using System.Web.Http.Results;

namespace Rentoolo.Controllers
{
    [Route("[controller]")]
    public class KitchenController : ApiController
    {
        public IHttpActionResult GetTop5Recipes()
        {
            List<Recipes> result = new List<Recipes>();

            result.Add(new Recipes
            {
                Name = "Воздушные блины на пахте",
                ImgUrl = "/img/kitchen/vozdushnie-blini-na-pahte.jpg",
                CountLikes = 720,
                TimeMinutesToCook = 15
            });

            result.Add(new Recipes
            {
                Name = "Фалафель с овощами",
                ImgUrl = "/img/kitchen/falafel-s-ovoshami.jpg",
                CountLikes = 345,
                TimeMinutesToCook = 25
            });

            result.Add(new Recipes
            {
                Name = "Говядина в фруктовом маринаде",
                ImgUrl = "/img/kitchen/govadina-v-fruktovom-marinade.jpg",
                CountLikes = 450,
                TimeMinutesToCook = 40
            });

            result.Add(new Recipes
            {
                Name = "Венские вафли",
                ImgUrl = "/img/kitchen/venskie-vafli.jpg",
                CountLikes = 120,
                TimeMinutesToCook = 15
            });

            result.Add(new Recipes
            {
                Name = "Картофель по-домашнему с тушеными овощами",
                ImgUrl = "/img/kitchen/kartofel-po-domashnemu-s-tushenimi-ovoshami.jpg",
                CountLikes = 570,
                TimeMinutesToCook = 25
            });

            result.Add(new Recipes
            {
                Name = "Суши сет и роллы",
                ImgUrl = "/img/kitchen/sushi-set-i-rolli.jpg",
                CountLikes = 210,
                TimeMinutesToCook = 60
            });

            return Json(result);
        }
    }
}
