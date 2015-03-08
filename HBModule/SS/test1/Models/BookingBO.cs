using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace test1.Models
{
    public class BookingBO
    {
        public Int64 PropertyId { get; set; }

        public decimal SingleOccupancy { get; set; }

        public decimal doubleOccupancy { get; set; }

        public string PropertyImage { get; set; }

        public string PropertyName { get; set; }

        public decimal Total_Tariff { get; set; }

        public string CheckIn { get; set; }

        public string Checkout { get; set; }

        public string RoomCount { get; set; }

        public string GuestCount { get; set; }

        public string ImageLocation { get; set; }



        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmployeeCode { get; set; }
        public string Designation { get; set; }
        public string Email { get; set; }
        public string Phno { get; set; }
    }
}