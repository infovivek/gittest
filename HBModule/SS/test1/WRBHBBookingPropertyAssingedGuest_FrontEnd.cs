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
    
    public partial class WRBHBBookingPropertyAssingedGuest_FrontEnd
    {
        public long BookingId { get; set; }
        public string EmpCode { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public long GuestId { get; set; }
        public string Occupancy { get; set; }
        public string RoomType { get; set; }
        public decimal Tariff { get; set; }
        public long RoomId { get; set; }
        public long BookingPropertyId { get; set; }
        public long BookingPropertyTableId { get; set; }
        public long SSPId { get; set; }
        public long Id { get; set; }
        public long CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public long ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.Guid RowId { get; set; }
        public string ServicePaymentMode { get; set; }
        public string TariffPaymentMode { get; set; }
        public Nullable<System.DateTime> ChkInDt { get; set; }
        public Nullable<System.DateTime> ChkOutDt { get; set; }
        public string ExpectChkInTime { get; set; }
        public string CancelRemarks { get; set; }
        public Nullable<bool> CancelModifiedFlag { get; set; }
        public string AMPM { get; set; }
        public Nullable<int> RoomCaptured { get; set; }
    }
}
