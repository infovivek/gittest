//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace test1
{
    using System;
    using System.Collections.Generic;
    
    public partial class WRBHBPropertyAgreementsOwner
    {
        public Nullable<long> AgreementId { get; set; }
        public Nullable<long> OwnerId { get; set; }
        public string OwnerName { get; set; }
        public Nullable<decimal> SplitPer { get; set; }
        public long Id { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public Nullable<System.Guid> RowId { get; set; }
    
        public virtual WRBHBPropertyAgreement WRBHBPropertyAgreement { get; set; }
        public virtual WRBHBPropertyOwner WRBHBPropertyOwner { get; set; }
    }
}
