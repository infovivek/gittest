using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class TravelDesk
    {
        public string ClientName { get; set; } 
        public string Designation { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }

        public string Address { get; set; } 
        public string City { get; set; }
        public string MobileNumber { get; set; }
        public string Office { get; set; }
        public string State { get; set; }

        public string Website { get; set; }  
        public int ClientId { get; set; }
        public int StateId { get; set; }
        public int CityId { get; set; }


        public int CreatedBy { get; set; }
        public int ModifiedBy { get; set; }
        public int Id { get; set; }

        public string Mode  { get; set; }
    }
}
