using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace Rentoolo.HelperModels
{
    public static class RusCities
    {

        public static bool CitiesExists = false;

        public static string[] AllRusCities = new string[0];
        
        public static void InitAllCities()
        {
            string pathToFile = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "HelperModels\\rus_cities2.json");

            pathToFile = pathToFile.Replace('\\','/');

            if (File.Exists(pathToFile))
            {
                string json = File.ReadAllText(pathToFile);
                AllRusCities = JsonConvert.DeserializeObject<string[]>(json);

                Console.WriteLine(AllRusCities[0]);
                CitiesExists = true;
            }
            
        }

    }
}