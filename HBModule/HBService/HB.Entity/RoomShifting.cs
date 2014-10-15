using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class RoomShifting
    {
        public int BookingId { get; set; }

        public int FromRoomId { get; set; }

        public string ChkInDt { get; set; }

        public string ChkOutDt { get; set; }

        public int ToRoomId { get; set; }

        public string ToRoomNo { get; set; }

        public string BookingLevel { get; set; }

        public int Id { get; set; }

        public int RoomCaptured { get; set; }

        public string CurrentStatus { get; set; }

        public string TariffMode { get; set; }

        public string ServiceMode { get; set; }
    }
}
