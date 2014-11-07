using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class Booking
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public int GradeId { get; set; }
        public int StateId { get; set; }
        public int CityId { get; set; }
        public string ClientName { get; set; }
        public string CheckInDate { get; set; }
        public string ExpectedChkInTime { get; set; }
        public string CheckOutDate { get; set; }        
        public string GradeName { get; set; }
        public string StateName { get; set; }
        public string CityName { get; set; }
        public string SpecialRequirements { get; set; }
        public string Sales { get; set; }
        public string CRM { get; set; }
        public bool EmailtoGuest { get; set; }
        public int ClientBookerId { get; set; }
        public string ClientBookerName { get; set; }
        public string ClientBookerEmail { get; set; }
        public string Note { get; set; }
        public string Status { get; set; }
        public string AMPM { get; set; }
        public string BookingLevel { get; set; }
        public string ExtraCCEmail { get; set; }
    }
}
