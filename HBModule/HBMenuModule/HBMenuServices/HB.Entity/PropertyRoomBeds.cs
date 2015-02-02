using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class PropertyRoomBeds
    {

        public int  RoomId { get; set; } 
        public decimal  BedRackTarrif { get; set; }
        public bool DiscountModePer  { get; set; }
        public bool  DiscountModeRS { get; set; }

        public decimal DiscountAllowed  { get; set; }
        public string BedName { get; set; }
        public string CreatedBy { get; set; }
        public int Id { get; set; } 
 

    }
}
