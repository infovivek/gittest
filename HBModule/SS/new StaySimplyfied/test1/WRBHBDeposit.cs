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
    
    public partial class WRBHBDeposit
    {
        public System.DateTime DepositedDate { get; set; }
        public decimal Amount { get; set; }
        public long DepositeToId { get; set; }
        public long DepositedBy { get; set; }
        public string Comments { get; set; }
        public string ChallanImage { get; set; }
        public string Mode { get; set; }
        public long Id { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public long CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public long ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public System.Guid RowId { get; set; }
        public string ImageName { get; set; }
        public Nullable<long> PropertyId { get; set; }
        public string InvoiceNo { get; set; }
        public Nullable<decimal> TotalAmount { get; set; }
        public string BTCTo { get; set; }
        public string BTCMode { get; set; }
        public string DoneBy { get; set; }
        public string ChequeNo { get; set; }
        public Nullable<long> ChkOutHdrId { get; set; }
        public Nullable<long> ClientId { get; set; }
    }
}