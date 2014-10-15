using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;


namespace HB.Entity
{
    public class ExternalChechkOutTAC
    {
        public int Id { get; set; }
        public int ChkOutHdrId { get; set; }
        public string TACInvoiceNo { get; set; }
        public string TACInvoiceFile { get; set; }
        public string GuestName { get; set; }
        public string Stay { get; set; }
        public string Type { get; set; }
  //      public string BookingLevel { get; set; }
        public string BillDate { get; set; }
        public string ClientName { get; set; }
        public string Property { get; set; }
        public decimal TotalTariff { get; set; }
        public decimal NetAmount { get; set; }
        public decimal SerivceTax { get; set; }
        public decimal Cess { get; set; }
        public decimal HECess { get; set; }
        public string Referance { get; set; }
        public int ChkInHdrId { get; set; }
        public int NoOfDays { get; set; }
        public int RoomId { get; set; }
        public int PropertyId { get; set; }
        public int BookingId { get; set; }
        public int GuestId { get; set; }
        public int StateId { get; set; }
        public string Direct { get; set; }
        public string PropertyType { get; set; }
        public string Status { get; set; }
        public string CheckInDate { get; set; }
        public string CheckOutDate { get; set; }
        public decimal MarkUpAmount { get; set; }
        public decimal BusinessSupportST { get; set; }
        public decimal Rate { get; set; }

    }
}
