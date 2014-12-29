using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class CheckoutAndIntermediate
    {
        public int Id { get; set; }
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
        public int PropertyId { get; set; }
        public int BookingId { get; set; }
        public int GuestId { get; set; }
        public int StateId { get; set; }
        public string Direct { get; set; }
        public string BTC { get; set; }
        public string PropertyType { get; set; }
        public string Status { get; set; }
        public decimal STAgreedAmount { get; set; }
        public decimal LTAgreedAmount { get; set; }
        public decimal STRackAmount { get; set; }
        public decimal LTRackAmount { get; set; }
        public decimal LTTaxPer { get; set; }
        public decimal STTaxPer { get; set; }
        public decimal VATPer { get; set; }
        public decimal RestaurantSTPer { get; set; }
        public decimal BusinessSupportST { get; set; }
        public string CheckInDate { get; set; }
        public string CheckOutDate { get; set; }
        public string InVoiceNo { get; set; }
        public int ClientId { get; set; }
        public int CityId { get; set; }
        public int ServiceChargeChk { get; set; }
        public string BillFromDate { get; set; }
        public string BillEndDate { get; set; }
        public string Intermediate { get; set; }
        public bool Preformainvoice { get; set; }
        public string Email { get; set; }
    }
}
