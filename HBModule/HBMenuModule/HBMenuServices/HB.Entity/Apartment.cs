using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
  public class Apartment
    {
     public int PropertyId { get; set; }
     public int BlockId { get; set; }
     public string BlockName { get; set; }
     public string ApartmentName { get; set; }
     public string ApartmentType { get; set; }
     public string ApartmentNo { get; set; }
     public string SellableApartmentType { get; set; }
     public string OwnershipType { get; set; }
     public decimal RackTariff { get; set; }
     public bool DiscountModePer { get; set; }
     public bool DiscountModeRS { get; set; }
     public decimal DiscountAllowed { get; set; }
     public string Status { get; set; }
     public string CreatedBy { get; set; }
     public int Id { get; set; } 
    }
}
