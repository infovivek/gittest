using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class TIAandATIAEntity
    {
        public int Id { get; set; }
        public int PropertyId { get; set; }
        public int OwnerId { get; set; }
        public int AdjustmentAmount { get; set;}
        public string Description { get; set;}
        public string AdjustmentType { get; set;}
        public string AdjustmentCategory { get; set;}
        public string AdjustmentMonth { get; set; }
        public Boolean Flag { get; set; }
    }
}
