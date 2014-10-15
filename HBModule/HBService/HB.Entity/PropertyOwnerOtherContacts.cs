using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class PropertyOwnerOtherContacts
    {
        public int OwnerId { get; set; }       
        public String Name { get; set; }
        public String EmailId { get; set; }
        public String ContactType { get; set; }
        public String PhoneNumber { get; set; }
        public String designation { get; set; }       
        public int CreatedBy { get; set; }
        public int Id { get; set; }
    }
}
