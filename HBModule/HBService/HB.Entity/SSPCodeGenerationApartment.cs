using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class SSPCodeGenerationApartment
    {
        public int SSPCodeGenerationId { get; set; }

        public string ApartmentNo { get; set; }

        public string ApartmentType { get; set; }

        public decimal SingleTariff { get; set; }

        public decimal DoubleTariff { get; set; }

        public int ApartmentId { get; set; }

        public int CreatedBy { get; set; }

        public int Id { get; set; }
    }
}
