using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class BookingGuestDetails
    {
        public string EmpCode { get; set; }
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Grade { get; set; }
        public string Designation { get; set; }
        public string EmailId { get; set; }
        public string MobileNo { get; set; }
        public string Nationality { get; set; }
        public int GuestId { get; set; }
        public int GradeId { get; set; }
        public int Id { get; set; }
    }
}
