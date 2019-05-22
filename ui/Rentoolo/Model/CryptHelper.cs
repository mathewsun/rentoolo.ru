using System;
using System.Security.Cryptography;
using System.Text;
using System.Xml;

namespace Rentoolo.Model
{
    public class CryptHelper
    {
        static public byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

        static public string GetString(byte[] bytes)
        {
            char[] chars = new char[bytes.Length / sizeof(char)];
            System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
            return new string(chars);
        }

        static public byte[] RSAEncrypt(byte[] DataToEncrypt, RSAParameters RSAKeyInfo, bool DoOAEPPadding)
        {
            try
            {
                byte[] encryptedData;
                //Create a new instance of RSACryptoServiceProvider.
                using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
                {

                    //Import the RSA Key information. This only needs
                    //toinclude the public key information.
                    RSA.ImportParameters(RSAKeyInfo);

                    //Encrypt the passed byte array and specify OAEP padding.  
                    //OAEP padding is only available on Microsoft Windows XP or
                    //later.  
                    encryptedData = RSA.Encrypt(DataToEncrypt, DoOAEPPadding);
                }
                return encryptedData;
            }
            //Catch and display a CryptographicException  
            //to the console.
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);

                return null;
            }

        }

        static public byte[] RSADecrypt(byte[] DataToDecrypt, RSAParameters RSAKeyInfo, bool DoOAEPPadding)
        {
            try
            {
                byte[] decryptedData;
                //Create a new instance of RSACryptoServiceProvider.
                using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
                {
                    //Import the RSA Key information. This needs
                    //to include the private key information.
                    RSA.ImportParameters(RSAKeyInfo);

                    //Decrypt the passed byte array and specify OAEP padding.  
                    //OAEP padding is only available on Microsoft Windows XP or
                    //later.  
                    decryptedData = RSA.Decrypt(DataToDecrypt, DoOAEPPadding);
                }
                return decryptedData;
            }
            //Catch and display a CryptographicException  
            //to the console.
            catch (CryptographicException e)
            {
                //Console.WriteLine(e.ToString());

                DataHelper.AddException(e);

                return null;
            }
        }

        static public byte[] CryptString(string value)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load("key.xml");

            byte[] encryptedData;
            byte[] dataToEncrypt = CryptHelper.GetBytes(value);

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                RSA.FromXmlString(doc.OuterXml);

                encryptedData = CryptHelper.RSAEncrypt(dataToEncrypt, RSA.ExportParameters(false), false);
            }

            return encryptedData;
        }

        public static string DeCryptString(byte[] value)
        {
            string result;

            using (RSACryptoServiceProvider RSAxml = new RSACryptoServiceProvider())
            {
                byte[] decryptedData;

                RSAxml.FromXmlString(SettingsDbConnection.PrivateKeyXml);

                decryptedData = CryptHelper.RSADecrypt(value, RSAxml.ExportParameters(true), false);

                result = CryptHelper.GetString(decryptedData);
            }

            return result;
        }

        public static string Sha256(string value)
        {
            SHA256Managed crypt = new SHA256Managed();
            string hash = String.Empty;
            byte[] crypto = crypt.ComputeHash(Encoding.ASCII.GetBytes(value), 0, Encoding.ASCII.GetByteCount(value));
            foreach (byte theByte in crypto)
            {
                hash += theByte.ToString("x2");
            }
            return hash;
        }
    }
}