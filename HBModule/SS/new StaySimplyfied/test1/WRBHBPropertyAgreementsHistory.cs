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
    
    public partial class WRBHBPropertyAgreementsHistory
    {
        public Nullable<long> PropertyId { get; set; }
        public System.DateTime DateOfAgreement { get; set; }
        public System.DateTime RentalStartDate { get; set; }
        public long NoticePeriod { get; set; }
        public Nullable<long> LockInPeriod { get; set; }
        public decimal StartingRentalMonth { get; set; }
        public string RentalType { get; set; }
        public Nullable<System.DateTime> StartingMaintenanceMonth { get; set; }
        public Nullable<decimal> MaintenanceAmount { get; set; }
        public long Tenure { get; set; }
        public System.DateTime ExpiryDate { get; set; }
        public bool RentInclusive { get; set; }
        public string Escalation { get; set; }
        public string DurationEscalation { get; set; }
        public long Id { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.Guid RowId { get; set; }
        public string AssociationName { get; set; }
        public Nullable<long> AssociationId { get; set; }
        public Nullable<long> ApartmentId { get; set; }
        public string ApartmentName { get; set; }
        public Nullable<long> OwnerPropertyId { get; set; }
        public string PropertyName { get; set; }
        public string Paid { get; set; }
        public Nullable<System.DateTime> AdvanceDate { get; set; }
        public string AdvanceType { get; set; }
        public string ChqNeft { get; set; }
        public Nullable<decimal> AdvanceAmount { get; set; }
        public string MaintenanceType { get; set; }
        public string Bank { get; set; }
        public Nullable<bool> Status { get; set; }
        public Nullable<bool> TAC { get; set; }
        public Nullable<decimal> TACPer { get; set; }
        public Nullable<System.DateTime> LastPaidMonth { get; set; }
    }
}