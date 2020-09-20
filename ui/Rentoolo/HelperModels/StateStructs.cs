using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.HelperModels
{
    public static class StateStructs
    {
        // in table UserViews field Type
        public static Dictionary<string, int> ViewedType = new Dictionary<string, int>
        {
            { "product", 1 },
            { "vacancy", 2 },
        };

        public enum ViewKeys
        {
            Product = 0,
            Vacancy
        }

        public static ViewKeys ViewKeyWords = new ViewKeys();


    }
}