using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractClientPreferDtl
    {
        public string Property { get; set; }
        public string RoomType { get; set; }
        public decimal TariffSingle { get; set; }
        public decimal TariffDouble { get; set; }
        public decimal TariffTriple { get; set; }
        public string Facility { get; set; }
        public bool Inclusive { get; set; }
        public decimal Tax { get; set; }
        public int PropertyId { get; set; }
        public int RoomId { get; set; }
        public int ContractClientprefHdrId { get; set; }
        public int Id { get; set; }
        public string ContactName { get; set; }
        public string ContactPhone { get; set; }
        public string ContactEmail { get; set; }
    }
}
