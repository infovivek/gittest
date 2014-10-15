using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class TAxMaster
    {
        public int     Id { get; set; }
        public decimal Cess { get; set; }
        public decimal HECess { get; set; }
        public decimal VAT { get; set; }
        public decimal ServiceAmount { get; set; }
        public decimal TariffAmtFrom { get; set; }
        public decimal TariffAmtTo { get; set; }
        public decimal Taxper { get; set; }
        public decimal TariffAmtFrom1 { get; set; }
        public decimal TariffAmtTo1 { get; set; }
        public decimal Taxper1 { get; set; }
        public decimal TariffAmtFrom2 { get; set; }
        public decimal TariffAmtTo2 { get; set; }
        public decimal Taxper2 { get; set; }
        public decimal TariffAmtFrom3 { get; set; }
        public decimal TariffAmtTo3 { get; set; }
        public decimal Taxper3 { get; set; }
        public string  State { get; set; }
        public int     StateId { get; set; }
        public string  Date { get; set; }
        public string  VATNo { get; set; }
        public string  LuxuryNo { get; set; }
        public string ServiceNo { get; set; }
        public decimal RestaurantST { get; set; }
        public decimal BusinessSupportST { get; set; }
        public bool RackTariff { get; set; }
        public string TINNumber { get; set; }
        public string CINNumber { get; set; } 
    }
}
