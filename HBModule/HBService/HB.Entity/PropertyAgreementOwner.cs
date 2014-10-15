using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PropertyAgreementOwner
    {
        public int AgreementId { get; set; }
        public int OwnerId { get; set; }
        public string OwnerName { get; set; }
        public decimal SplitPer { get; set; }
        public string CreatedBy { get; set; }
        public int Id { get; set; }
    }
}
