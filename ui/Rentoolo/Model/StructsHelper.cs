using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rentoolo.Model
{
    public static class StructsHelper
    {

        // some Tables have field Type which is assigned to some site section
        //and this struct is made to help get value of Type field 



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