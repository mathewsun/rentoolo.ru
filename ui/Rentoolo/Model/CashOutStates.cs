using System;
using System.Collections.Generic;

namespace Rentoolo.Model
{
    public enum CashOutStatesEnum
    {
        /// <summary>
        /// Запрошен
        /// </summary>
        Entered = 1,

        /// <summary>
        /// Выдан
        /// </summary>
        Finished = 2,

        /// <summary>0
        /// Отклонен администратором
        /// </summary>
        Rejected = 3
    }

    public class CashOutStates
    {
        /// <summary>
        /// Идентификатор
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Название
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Конструктор
        /// </summary>
        public CashOutStates(int id)
        {
            Id = id;
            Name = GetName(Id);
        }

        /// <summary>
        /// Конструктор
        /// </summary>
        private CashOutStates()
        {
        }

        /// <summary>
        /// Получение списка
        /// </summary>
        public static List<CashOutStates> GetList()
        {
            List<CashOutStates> list = new List<CashOutStates>();

            foreach (CashOutStatesEnum item in Enum.GetValues(typeof(CashOutStatesEnum)))
                list.Add(new CashOutStates((int)item));

            return list;
        }

        /// <summary>
        /// Получение название
        /// </summary>
        public static string GetName(int value)
        {
            string name = "Нет такой операции";

            switch ((CashOutStatesEnum)value)
            {
                case CashOutStatesEnum.Entered:
                    name = "В очереди";
                    break;
                case CashOutStatesEnum.Finished:
                    name = "Выдан";
                    break;
                case CashOutStatesEnum.Rejected:
                    name = "Отклонен";
                    break;
            }

            return name;
        }
    }
}