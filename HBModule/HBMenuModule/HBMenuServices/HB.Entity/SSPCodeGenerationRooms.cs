using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class SSPCodeGenerationRooms
    {
        public int SSPCodeGenerationId { get; set; }

        public int RoomId { get; set; }

        public string RoomNo { get; set; }

        public decimal SingleTariff { get; set; }

        public decimal DoubleTariff { get; set; }

        public int CreatedBy { get; set; }

        public int Id { get; set; }
    }
}
