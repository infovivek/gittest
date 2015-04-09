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
    
    public partial class WRBHBClientGradeValue
    {
        public WRBHBClientGradeValue()
        {
            this.WRBHBClientGradeValueDetails = new HashSet<WRBHBClientGradeValueDetail>();
        }
    
        public Nullable<long> ClientId { get; set; }
        public Nullable<long> GradeId { get; set; }
        public Nullable<decimal> MinValue { get; set; }
        public Nullable<decimal> MaxValue { get; set; }
        public long Id { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<bool> IsActive { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public Nullable<System.Guid> RowId { get; set; }
        public string Grade { get; set; }
        public Nullable<bool> NeedGH { get; set; }
        public Nullable<bool> ValueStarRatingFlag { get; set; }
        public Nullable<long> StarRatingId { get; set; }
    
        public virtual WRBHBClientManagement WRBHBClientManagement { get; set; }
        public virtual ICollection<WRBHBClientGradeValueDetail> WRBHBClientGradeValueDetails { get; set; }
    }
}