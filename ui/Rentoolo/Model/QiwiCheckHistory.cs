using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;
using xNet;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace Rentoolo.Model
{
    public class QiwiCheckHistory
    {
        
        public QiwiCheckHistory()
        {
            
        }

        

        public bool auth(string login, string pass)
        {
            bool check = false;
            
            return check;
        }

        public void CheckPaymentsHistory(string login, string pass)
        {
            
        }

        static string DateTimeToUnixTimestamp(DateTime dateTime)
        {
            TimeSpan span = (DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc));
            return (span.TotalMilliseconds).ToString("0");
        }
    }
}