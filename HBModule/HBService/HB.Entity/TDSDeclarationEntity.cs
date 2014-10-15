using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class TDSDeclarationEntity
    {
        public int Id { get; set; }
        public int PropertyId { get; set; }
        public int OwnerId { get; set; }
        public string PanNo { get; set; }
        public int TDSPercentage { get; set; }
        public string Date { get; set; }
        public string FinancialYear { get; set; }
        public string Image { get; set; }
    }
}
