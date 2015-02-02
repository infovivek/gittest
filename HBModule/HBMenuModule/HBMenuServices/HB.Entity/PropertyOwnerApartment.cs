using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PropertyOwnerApartment
    { 
        public int OwnerId { get; set; }
        public int ApartmentId { get; set; }
        public String ApartmentName { get; set; }
        public int CreatedBy { get; set; }

        public int Id { get; set; }
    }
}
