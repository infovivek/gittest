using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ApartmentBookingProperty
    {
        public string PropertyName { get; set; }
        public int PropertyId { get; set; }
        public string GetType { get; set; }
        public string PropertyType { get; set; }
        public decimal Tariff { get; set; }
        public decimal Discount { get; set; }
        public decimal DiscountedTariff { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Locality { get; set; }
        public int LocalityId { get; set; }
        public bool Per { get; set; }
        public bool Rs { get; set; }
        public decimal DiscountAllowed { get; set; }
        public int Id { get; set; }
    }
}
