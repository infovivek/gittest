using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class Vendor
    {
        public string Category  { get; set; }
        public string VendorName { get; set; }
        public string Designation { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
       
        public string Address { get; set; }
        public string NatureOfService  { get; set; }
        public string City { get; set; }
        public string MobileNumber { get; set; } 
        public string Office { get; set; }
        public string State { get; set; }
      
        public string Website { get; set; }
        public string Pancard { get; set; }

        public int CategoryId  { get; set; }
        public int StateId  { get; set; }
        public int CityId  { get; set; }


        public int CreatedBy { get; set; }
        public int ModifiedBy { get; set; }
        public int Id { get; set; }
        
        public string saletaxdate { get; set; }
        public string ServtaxNum { get; set; }
        public string servicetaxdate { get; set; }
        public bool Cheque { get; set; }
        public bool OnlineTransfer { get; set; }
        public string Bank { get; set; }
        public string PayeeName { get; set; }
        public string IFSC { get; set; }

        public string AccountNo { get; set; }
        public string AccountType { get; set; }
        public string PaymentCircle { get; set; } 
    }
}
