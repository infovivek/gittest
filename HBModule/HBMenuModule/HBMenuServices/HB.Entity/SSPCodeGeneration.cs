using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class SSPCodeGeneration
    {
        public int ClientId { get; set; }

        public int PropertyId { get; set; }

        public string SSPCode { get; set; }

        public string SSPName { get; set; }

        public string BookingLevel { get; set; }

        public decimal SingleTariff { get; set; }

        public decimal DoubleTariff { get; set; }

        public decimal TripleTariff { get; set; }

        public int CreatedBy { get; set; }

        public int Id { get; set; }
    }
}
