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
    
    public partial class WRBHBState
    {
        public WRBHBState()
        {
            this.WRBHBCities = new HashSet<WRBHBCity>();
        }
    
        public string StateName { get; set; }
        public int Id { get; set; }
        public bool IsActive { get; set; }
    
        public virtual ICollection<WRBHBCity> WRBHBCities { get; set; }
    }
}
