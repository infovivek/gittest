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
    
    public partial class WRBHBContractNonDedicatedApartment
    {
        public long NondedContractId { get; set; }
        public string ApartMentType { get; set; }
        public Nullable<decimal> ApartTarif { get; set; }
        public decimal RoomTarif { get; set; }
        public decimal DoubleTarif { get; set; }
        public decimal BedTarif { get; set; }
        public Nullable<long> RoomId { get; set; }
        public Nullable<long> ApartmentId { get; set; }
        public Nullable<long> BedId { get; set; }
        public long Id { get; set; }
        public long CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public long ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.Guid RowId { get; set; }
        public Nullable<long> PropertyId { get; set; }
        public string Property { get; set; }
        public string PropertyCategory { get; set; }
        public Nullable<decimal> TripleTarif { get; set; }
        public string Description { get; set; }
    
        public virtual WRBHBContractNonDedicated WRBHBContractNonDedicated { get; set; }
    }
}
