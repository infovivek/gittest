using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PaxInOut
    {
        public int Id { get; set; }
        public int ChkInHdrId { get; set; }
        public int RoomId { get; set; }
        public bool InOut { get; set; }
        public string Date { get; set; }
        public string Time { get; set; }
        public int Male { get; set; }
        public int Female { get; set; }
        public int Child { get; set; }
        public decimal Tariff { get; set; }
        public decimal Tax { get; set; }
        public decimal Cess { get; set; }
        public decimal HECess { get; set; }
        public decimal VAT { get; set; }
        public decimal ServiceTax { get; set; }
        public decimal Luxury { get; set; }
        public decimal ExtraBed { get; set; }
        public int TaxId { get; set; }
        public int PropertyId { get; set; }
        public string Property { get; set; }
    }
}
