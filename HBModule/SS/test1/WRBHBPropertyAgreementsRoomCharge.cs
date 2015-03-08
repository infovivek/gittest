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
    
    public partial class WRBHBPropertyAgreementsRoomCharge
    {
        public Nullable<long> AgreementId { get; set; }
        public Nullable<decimal> RackSingle { get; set; }
        public Nullable<decimal> RackDouble { get; set; }
        public Nullable<decimal> Tax { get; set; }
        public Nullable<bool> Inclusive { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public string RoomType { get; set; }
        public long Id { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public Nullable<System.Guid> RowId { get; set; }
        public string Facility { get; set; }
        public Nullable<decimal> RackTriple { get; set; }
        public string Description { get; set; }
        public Nullable<decimal> Single { get; set; }
        public Nullable<decimal> RDouble { get; set; }
        public Nullable<decimal> Triple { get; set; }
        public Nullable<decimal> STRack { get; set; }
        public Nullable<decimal> STAgreed { get; set; }
        public Nullable<decimal> LTRack { get; set; }
        public Nullable<decimal> LTAgreed { get; set; }
        public Nullable<decimal> SC { get; set; }
        public Nullable<bool> Visible { get; set; }
    
        public virtual WRBHBPropertyAgreement WRBHBPropertyAgreement { get; set; }
    }
}
