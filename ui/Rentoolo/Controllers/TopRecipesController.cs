using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Rentoolo.Controllers.KitchenModel;

namespace Rentoolo.Controllers
{
    public class TopRecipesController : ApiController
    {
        public IHttpActionResult Get()
        {
            List<Recipe> result = new List<Recipe>();

            result.Add(new Recipe
            {
                Name = "Воздушные блины на пахте",
                ImgUrl = "https://www.rentoolo.ru/img/kitchen/vozdushnie-blini-na-pahte.jpg",
                CountLikes = 720,
                TimeMinutesToCook = 15,
                UserId = 1,
                UserName = "Мария Иванова",
                UserAvatarImgUrl = "https://www.rentoolo.ru/img/kitchen/avatars/69179930_736853823483887_5740857891485646848_n.jpg"
            });

            result.Add(new Recipe
            {
                Name = "Фалафель с овощами",
                ImgUrl = "https://www.rentoolo.ru/img/kitchen/falafel-s-ovoshami.jpg",
                CountLikes = 345,
                TimeMinutesToCook = 25,
                UserId = 2,
                UserName = "Виктория Петрова",
                UserAvatarImgUrl = "https://www.rentoolo.ru/img/kitchen/avatars/69527679_631739310686765_4819614499147350016_n.jpg"
            });

            result.Add(new Recipe
            {
                Name = "Говядина в фруктовом маринаде",
                ImgUrl = "https://www.rentoolo.ru/img/kitchen/govadina-v-fruktovom-marinade.jpg",
                CountLikes = 450,
                TimeMinutesToCook = 40,
                UserId = 3,
                UserName = "Евгения Григорьева",
                UserAvatarImgUrl = "https://www.rentoolo.ru/img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg"
            });

            result.Add(new Recipe
            {
                Name = "Венские вафли",
                ImgUrl = "https://www.rentoolo.ru/img/kitchen/venskie-vafli.jpg",
                CountLikes = 120,
                TimeMinutesToCook = 15,
                UserId = 4,
                UserName = "Александра Лебедь",
                UserAvatarImgUrl = "https://www.rentoolo.ru/img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg"
            });

            result.Add(new Recipe
            {
                Name = "Картофель по-домашнему с тушеными овощами",
                ImgUrl = "https://www.rentoolo.ru/img/kitchen/kartofel-po-domashnemu-s-tushenimi-ovoshami.jpg",
                CountLikes = 570,
                TimeMinutesToCook = 25,
                UserId = 5,
                UserName = "Екатерина Гагарина",
                UserAvatarImgUrl = "https://www.rentoolo.ru/img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg"
            });

            result.Add(new Recipe
            {
                Name = "Суши сет и роллы",
                ImgUrl = "https://www.rentoolo.ru/img/kitchen/sushi-set-i-rolli.jpg",
                CountLikes = 210,
                TimeMinutesToCook = 60,
                UserId = 6,
                UserName = "Анастасия Максимова",
                UserAvatarImgUrl = "https://www.rentoolo.ru/img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg"
            });

            return Json(result);
        }
    }
}
