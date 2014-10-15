using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
  public  class PropertyRoom
    {
        public int PropertyId { get; set; }
        public int BlockId { get; set; }
        public string BlockName { get; set; } 
        public string ApartmentNo { get; set; }
        public int ApartmentId { get; set; } 
        public string RoomType { get; set; }
        public string RoomNo { get; set; }
        public decimal RackTariff { get; set; }  
        public decimal DoubleOccupancyTariff { get; set; } 
        public string RoomCategory { get; set; }
        public string RoomStatus { get; set; }

        public bool DiscountModePer { get; set; }
        public bool DiscountModeRS { get; set; }
        public decimal DiscountAllowed { get; set; }

        public string CreatedBy { get; set; }
        public int Id { get; set; } 
    }
}
