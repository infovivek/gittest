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
    
    public partial class WRBHBUserRole
    {
        public long UserId { get; set; }
        public int RolesId { get; set; }
        public string Roles { get; set; }
        public long Id { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public System.Guid RowId { get; set; }
    
        public virtual WRBHBRole WRBHBRole { get; set; }
    }
}