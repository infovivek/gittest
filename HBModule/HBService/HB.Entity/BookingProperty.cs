using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class BookingProperty
    {
        public string PropertyName { get; set; }
        public Int64 PropertyId { get; set; }
        public string GetType { get; set; }
        public string PropertyType { get; set; }
        public string RoomType { get; set; }
        public decimal SingleTariff { get; set; }
        public decimal DoubleTariff { get; set; }
        public decimal TripleTariff { get; set; }
        public decimal SingleandMarkup { get; set; }
        public decimal DoubleandMarkup { get; set; }
        public decimal TripleandMarkup { get; set; }
        public decimal Markup { get; set; }
        public decimal SingleandMarkup1 { get; set; }
        public decimal DoubleandMarkup1 { get; set; }
        public decimal TripleandMarkup1 { get; set; }
        public bool TAC { get; set; }
        public string Inclusions { get; set; }
        public bool DiscountModeRS { get; set; }
        public bool DiscountModePer { get; set; }
        public decimal DiscountAllowed { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Locality { get; set; }
        public int LocalityId { get; set; }
        public int Id { get; set; }
        public int MarkupId { get; set; }
        //
        public string RatePlanCode { get; set; }
        public string RoomTypeCode { get; set; }
        public int APIHdrId { get; set; }
        //
        public string TaxAdded { get; set; }
        // 29 DEC 2014
        public decimal LTAgreed { get; set; }
        public decimal STAgreed { get; set; }
        public decimal LTRack { get; set; }
        public decimal BaseTariff { get; set; }
        public bool TaxInclusive { get; set; }
        //
        public decimal GeneralMarkup { get; set; }
        public decimal SC { get; set; }
    }
}
