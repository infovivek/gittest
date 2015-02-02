using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class ExternalIntermediateCheckOut
    {
        // Header
        public int Id { get; set; }
        public string InVoiceNo { get; set; }
        public int CheckOutNo { get; set; }
        public string GuestName { get; set; }
        public string Stay { get; set; }
        public string Type { get; set; }
        public string BookingLevel { get; set; }
        public string BillDate { get; set; }
        public string ClientName { get; set; }
        public string Property { get; set; }
        public decimal TotalTariff { get; set; }
        public decimal NetAmount { get; set; }
        public decimal AdditionalCharge { get; set; }
        public decimal Discountperday { get; set; }
        public decimal TotalDiscount { get; set; }
        public decimal LuxuryTax { get; set; }
        public decimal SerivceTax { get; set; }
        public decimal SerivceNet { get; set; }
        public decimal ServiceCharge { get; set; }
        public decimal ServiceTaxService { get; set; }
        public decimal Cess { get; set; }
        public decimal HECess { get; set; }
        public string Referance { get; set; }
        public string Name { get; set; }
        public string ExtraType { get; set; }
        public int ExtraDays { get; set; }
        public decimal ExtraAmount { get; set; }
        public int ChkInHdrId { get; set; }
        public int NoOfDays { get; set; }
        public int RoomId { get; set; }
        public int ApartmentId { get; set; }
        public int BedId { get; set; }
        public string CheckInType { get; set; }
        public string ApartmentNo { get; set; }
        public string BedNo { get; set; }
        public Int64 PropertyId { get; set; }
        public int BookingId { get; set; }
        public int GuestId { get; set; }
        public int StateId { get; set; }
        public string Direct { get; set; }
        public string BTC { get; set; }
        public string PropertyType { get; set; }
        public decimal STAgreedAmount { get; set; }
        public decimal LTAgreedAmount { get; set; }
        public decimal STRackAmount { get; set; }
        public decimal LTRackAmount { get; set; }
        public string Status { get; set; }
        public string CheckInDate { get; set; }
        public string CheckOutDate { get; set; }
        public bool PrintInvoice { get; set; }
        // public string InVoiceNo { get; set; }
        public decimal LTTaxPer { get; set; }
        public decimal STTaxPer { get; set; }
        public decimal VATPer { get; set; }
        public decimal RestaurantSTPer { get; set; }
        public decimal BusinessSupportST { get; set; }
        public int ClientId { get; set; }
        public int CityId { get; set; }
        public string BillFromDate { get; set; }
        public string BillEndDate { get; set; }
        public string Intermediate { get; set; }
        public string Email { get; set; }

        // Details
        public int Id1 { get; set; }
        public int ChkOutHdrId { get; set; }
        public string TACInvoiceNo { get; set; }
        public string TACInvoiceFile { get; set; }
        public string GuestName1 { get; set; }
        //   public string Stay1 { get; set; }
        //   public string Type1 { get; set; }
        //      public string BookingLevel { get; set; }
        public string BillDate1 { get; set; }
        public string ClientName1 { get; set; }
        public string Property1 { get; set; }
        public decimal TotalTariff1 { get; set; }
        public decimal NetAmount1 { get; set; }
        //   public decimal SerivceTax1 { get; set; }
        public decimal Cess1 { get; set; }
        public decimal HECess1 { get; set; }
        public string Referance1 { get; set; }
        public int ChkInHdrId1 { get; set; }
        public int NoOfDays1 { get; set; }
        public int RoomId1 { get; set; }
        public Int64 PropertyId1 { get; set; }
        public int BookingId1 { get; set; }
        public int GuestId1 { get; set; }
        public int StateId1 { get; set; }
        public string Direct1 { get; set; }
        public string PropertyType1 { get; set; }
        public string Status1 { get; set; }
        public string CheckInDate1 { get; set; }
        public string CheckOutDate1 { get; set; }
        public decimal MarkUpAmount1 { get; set; }
        public decimal BusinessSupportST1 { get; set; }
        public decimal Rate1 { get; set; }
        public decimal TotalBusinessSupportST { get; set; }
        public decimal TACAmount { get; set; }
        public string BillFromDate1 { get; set; }
        public string BillEndDate1 { get; set; }
        public string Intermediate1 { get; set; }
       // public string Email1 { get; set; }
    }
}
