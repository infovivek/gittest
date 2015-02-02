using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class BookingCustomFieldsDetails
    {
        public int BookingId { get; set; }

        public int CustomFieldsId { get; set; }

        public string CustomFields { get; set; }

        public string CustomFieldsValue { get; set; }

        public string Mandatory { get; set; }

        public int CreatedBy { get; set; }

        public int Id { get; set; }

       
    }
}
