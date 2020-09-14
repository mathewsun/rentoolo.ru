using Rentoolo.Controllers.TenderModels;
using Rentoolo.DatabaseHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DBTenderRequest = Rentoolo.Model.TenderRequest;

namespace Rentoolo.Controllers
{
    public class TenderRequestController : ApiController
    {
        [HttpPost]
        public string PostTenderRequest([FromBody]TenderRequest model)
        {
            // TODO: rewrite by deleting Rentoolo.Controllers.TenderModels.TenderRequest model
            /*
            var headers = Request.Headers;
            var db = new Model.RentooloEntities();
            int currentUserId = Convert.ToInt32(headers.GetCookies("uid"));
            DBTenderRequest request = new DBTenderRequest()
            {
                Description = model.Description,
                Cost = Convert.ToInt32(model.Cost),
                // покупатель(customer) тот кто разместил обьявление
                CustomerId = model.UserOwnerId,
                TenderId = model.TenderId,
                // provider - current user which requests request on tender
                ProviderId = currentUserId,
                ProviderName = db.Users.Where(x => x.PublicId == currentUserId)
                .Select(x => x.UserName).First()
            };

            TendersHelper.CreateTenderRequest(request);
            */


            return "ok";
        }


    }
}
