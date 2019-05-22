using System;
using System.Configuration;

namespace Rentoolo.Model
{
    public static class SettingsDbConnection
    {
        #region Свойства

        #region Подключение к БД

        /// <summary>
        /// Подключение к БД по умолчанию
        /// </summary>
        public static string DefaultConnection
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            }
        }

        /// <summary>
        /// Таймаут подключения к БД
        /// </summary>
        public static int SqlCommandTimeout
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings["SqlCommandTimeout"]);
            }
        }

        #endregion

        public static string PrivateKeyXml
        {
            get
            {
                return "<RSAKeyValue><Modulus>ucdg/Pq9o8mSyvLS7CPfEAACbRboM5gRaAWwFmw2VwiQZMPUxf6tkyK/WLyQ/RbBdwV3eNxrnWp/FFLfZ3VRAwKBWDW/coSyZcQrUAyTpqT3CVxr8saskgaF/AOpfKcyS4vYUD+5tD3/JahPlms0mkczGM84MZgUuMX2E6gbZf0=</Modulus><Exponent>AQAB</Exponent><P>+vtYgtdHSxQpM49BKK0lxspX2YLRohdjEf3mmpArKO0cArRFe+0UHrUdmpFOckTsLH+63oyEVpJd7UcaiOltNw==</P><Q>vX5KZCBFmR83efzvM4ikCDgEUXsL1NJTmmuzrEkSjKkwqLuw2BU6Rc76oAbNzUR/pXn0ywHE1/xa4Kj+nStAaw==</Q><DP>Z4yR3RGy4WAFC7e7+2tMnbLYAe6+TPD3N/IYVYbLt8vz9Y2o6VNMLMsu1pnC0tRq2IUudSlmZE1pIT9nzDr6iw==</DP><DQ>DxTeFtn6sBUr9SmMYC2f4IeU0GdaqbWTsdagljW6pDdTCBroGEqYOLYgfFwORSgOgL0UHpQldos/MGJC4X9vwQ==</DQ><InverseQ>0VNGxtGu+vyIhRsT+d0PltqQiI5E/UD7hQ5Tn9lSdvXJl7D9oreZKZqP5Ab5nKseVISkyeQRFyd0WEo/21ClXA==</InverseQ><D>AJEjMqJxQbazw/rJuf7CB4J4f2y6eK3WH8MkrmzWHZ3hEu2mEJSeYvyQKO0qZBtVq89QdgX2LhzNFnrKQ76P6LkZHOyIn6LFwHY5NheLscjVXlHwTBBaP+EehQ3WdNq35yc4Kk4V2TG4tmnHTZAkjZe9/RwoUJVB224eVo1fB+E=</D></RSAKeyValue>";
            }
        }

        #endregion
    }
}