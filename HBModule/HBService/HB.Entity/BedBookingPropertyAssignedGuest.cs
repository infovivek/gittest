﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class BedBookingPropertyAssignedGuest
    {
        public string EmpCode { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int GuestId { get; set; }
        public string BedType { get; set; }
        public decimal Tariff { get; set; }
        public int RoomId { get; set; }
        public int BedId { get; set; }
        public int BookingPropertyId { get; set; }
        public int BookingPropertyTableId { get; set; }
        public int Id { get; set; }
        public int SSPId { get; set; }
        public string ServicePaymentMode { get; set; }
        public string TariffPaymentMode { get; set; }
    }
}
