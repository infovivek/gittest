using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class PropertyAgreementDetails
    {
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Escalation { get; set; }
        public decimal Rental { get; set; }
        public int Id { get; set; }
    }
}
