using System;
using System.Collections.Generic;

namespace Rentoolo.Model
{
    public enum OperationTypesEnum
    {
        /// <summary>
        /// Пополнение баланса
        /// </summary>
        AddBalance = 1,

        /// <summary>
        /// Пополнение счета за счет расхода реферала
        /// </summary>
        RefferalBonusAddSpend = 2,

        /// <summary>
        /// Пополнение счета за счет дохода реферала
        /// </summary>
        RefferalBonusAddIncome = 3,

        /// <summary>0
        /// Начисление ежедневных процентов
        /// </summary>
        AddPercents = 5,

        /// <summary>
        /// Смена персональных данных
        /// </summary>
        ChangePersonalData = 8,

        /// <summary>
        /// Регистрация на платформе
        /// </summary>
        Registration = 14,

        /// <summary>
        /// Перевод другому пользователю
        /// </summary>
        PaymentOut = 15,

        /// <summary>
        /// Перевод от другого пользователя
        /// </summary>
        PaymentIn = 16,

        /// <summary>
        /// Покупка токенов
        /// </summary>
        BuyingTokens = 17,

        /// <summary>
        /// Продажа токенов
        /// </summary>
        SellingTokens = 18,

        /// <summary>
        /// Смена или установление даты рождения
        /// </summary>
        BirthDayChange = 19
    }

    public class OperationTypes
    {
        /// <summary>
        /// Идентификатор пола сотрудника
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Название пола сотрудника
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Конструктор
        /// </summary>
        public OperationTypes(int id)
        {
            Id = id;
            Name = GetName(Id);
        }

        /// <summary>
        /// Конструктор
        /// </summary>
        private OperationTypes()
        {
        }

        /// <summary>
        /// Получение списка полов сотрудников
        /// </summary>
        public static List<OperationTypes> GetList()
        {
            List<OperationTypes> listSex = new List<OperationTypes>();

            foreach (OperationTypesEnum item in Enum.GetValues(typeof(OperationTypesEnum)))
                listSex.Add(new OperationTypes((int)item));

            return listSex;
        }

        /// <summary>
        /// Получение название пола сотрудника
        /// </summary>
        public static string GetName(int value)
        {
            string name = "Нет такой операции";

            switch ((OperationTypesEnum)value)
            {
                case OperationTypesEnum.AddBalance:
                    name = "Пополнение баланса";
                    break;
                case OperationTypesEnum.RefferalBonusAddSpend:
                    name = "Пополнение счета за счет расхода реферала";
                    break;
                case OperationTypesEnum.RefferalBonusAddIncome:
                    name = "Пополнение счета за счет дохода реферала";
                    break;
                case OperationTypesEnum.AddPercents:
                    name = "Начисление процентов";
                    break;
                case OperationTypesEnum.ChangePersonalData:
                    name = "Смена персональных данных";
                    break;
                case OperationTypesEnum.Registration:
                    name = "Регистрация на платформе";
                    break;
                case OperationTypesEnum.PaymentOut:
                    name = "Перевод пользователю";
                    break;
                case OperationTypesEnum.PaymentIn:
                    name = "Перевод от пользователя";
                    break;
                case OperationTypesEnum.BuyingTokens:
                    name = "Покупка токенов";
                    break;
                case OperationTypesEnum.SellingTokens:
                    name = "Продажа токенов";
                    break;
            }

            return name;
        }
    }
}