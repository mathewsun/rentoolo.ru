//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Rentoolo.Model
{
    using System;
    
    public partial class fnGetUserReferralsThirdLevel_Result
    {
        public int Id { get; set; }
        public System.Guid ReferrerUserId { get; set; }
        public System.Guid ReferralUserId { get; set; }
        public System.DateTime WhenDate { get; set; }
        public Nullable<int> PublicId { get; set; }
        public string UserName { get; set; }
        public Nullable<System.Guid> refererUp2Lvl { get; set; }
    }
}
