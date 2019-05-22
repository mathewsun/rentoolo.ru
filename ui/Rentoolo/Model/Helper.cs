using System;

namespace Rentoolo.Model
{
    public static class Helper
    {
        public static string TruncateLongString(this string str, int maxLength)
        {
            if (str == null) return string.Empty;

            return str.Substring(0, Math.Min(str.Length, maxLength));
        }

        public static string GetRefferalLink(System.Web.HttpRequest request, int userPublicId)
        {
            return string.Format("{0}/?refid={1}",
                    request.Url.Scheme + System.Uri.SchemeDelimiter + request.Url.Host,
                    userPublicId);
        }
    }
}