using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace test1.Models
{    
    public class InPBookingBO
    {
        public string PropertyName { get; set; }
        public string PropertyType { get; set; }
        public Int64 PropertyId { get; set; }
        //public string PropertyImage { get; set; }

        public Int64 ApartmentId { get; set; }
        public decimal Total_Tariff { get; set; }

        public string ApartmentType { get; set; }

        public string CheckIn { get; set; }

        public string Checkout { get; set; }

        public string RoomCount { get; set; }
        public string ImageLocation { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmployeeCode { get; set; }
        public string Designation { get; set; }
        public string Email { get; set; }
        public string Phno { get; set; }
        public string Level { get; set; }
        public Int64 RoomId { get; set; }
        public Int64 BedId { get; set; }

        public Int64? UserId { get; set; }
        public Int64? CliendId { get; set; }
        public string ClientName { get; set; }
        public Int64? stateId { get; set; }
        public Int64? cityId { get; set; }
        public string Grade { get; set; }
        public string CityName { get; set; }
        public string SateName { get; set; }
        public string specialrequst { get; set; }
        public string Nationality { get; set; }
        public string Title { get; set; }
        public string RoomType { get; set; }
        public string BedType { get; set; }
        public Int64 guestId { get; set; }
        public Int64? GradeId { get; set; }

        public string ServicePayMode { get; set; }
        public string TariffPayMode { get; set; }
    }

}