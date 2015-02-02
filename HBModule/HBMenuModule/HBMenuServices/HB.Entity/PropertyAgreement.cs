using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public  class PropertyAgreement
    { 
        public int OwnerId { get; set; }
        public int propertyId { get; set; }
        public String DateOfAgreement { get; set; } 
        public String RentalStartDate  { get; set; }
        public int  NoticePeriod  { get; set; }
        public int  LockInPeriod { get; set; }
        public decimal StartingRentalMonth { get; set; }
        public String  RentalType { get; set; }
        public String StartingMaintenanceMonth  { get; set; }
        public decimal  MaintenanceAmount { get; set; }
        public decimal Tenure { get; set; }
        public String  ExpiryDate { get; set; }
        public String AssociationName { get; set; }
        public bool RentInclusive { get; set; }
        public String Escalation { get; set; }
        public String DurationEscalation { get; set; }
        public int ApartmentId { get; set; }
        public String ApartmentName { get; set; }
        public int CreatedBy { get; set; } 
        public int Id { get; set; }
        public String Paid { get; set; }
        public decimal AdvanceAmount { get; set; }
        public string AdvanceType { get; set; }
        public string Bank { get; set; }
        public string ChqNeft{ get; set; }
        public string AdvanceDate { get; set; }
        public string MaintenanceType { get; set; }
        public bool Status { get; set; }
        public bool TAC { get; set; }
        public decimal TACPer { get; set; }
        //public int Check { get; set; }
        //public int Flag { get; set; }
        //public decimal Tariff { get; set; }
    }
}
