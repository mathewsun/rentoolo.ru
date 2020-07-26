using System;
using System.IO;
using System.Web;
using Rentoolo.Model;

namespace Rentoolo.Admin
{
    public class Result : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            using (var reader = new StreamReader(context.Request.InputStream))
            {
                //string postedData = reader.ReadToEnd();

                string eventName = string.Empty;
                string result = string.Empty;
                string id = string.Empty;
                string comment = string.Empty;

                eventName = context.Request["eventName"];
                result = context.Request["result"];
                id = context.Request["id"];
                comment = context.Request["comment"];

                //foreach (var item in postedData.Split(new[] { '&' }, StringSplitOptions.RemoveEmptyEntries))
                //{
                //    var tokens = item.Split(new[] { '=' }, StringSplitOptions.RemoveEmptyEntries);
                //    if (tokens.Length < 2)
                //    {
                //        continue;
                //    }

                //    var paramName = tokens[0];
                //    var paramValue = tokens[1];

                //}

                switch (eventName)
                {
                    case "cashoutresult":
                        int convertedId;

                        bool success = Int32.TryParse(id, out convertedId);
                        if (success)
                        {
                            if(result == "2")
                            {
                                DataHelper.UpdateCashOut(convertedId, (int)CashOutStatesEnum.Finished, string.Empty);
                            }

                            if (result == "3")
                            {
                                DataHelper.UpdateCashOut(convertedId, (int)CashOutStatesEnum.Rejected, string.Empty);
                            }
                        }
                        else
                        {
                            return;
                        }

                        break;

                    default:
                        break;
                }

            }

            context.Response.ContentType = "text/plain";
            context.Response.Write("Ok");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}