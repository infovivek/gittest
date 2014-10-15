using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractNonDedicatedApartment
    {
        public string ApartmentType { get; set; }
        public decimal RoomTariff { get; set; }
        public decimal DoubleTariff { get; set; }
        public decimal TripleTariff { get; set; }
        public decimal BedTariff { get; set; }
        public string Description { get; set; }
        public int RoomId { get; set; }
        public int ApartmentId { get; set; }
        public int BedId { get; set; }
        public int Id { get; set; }
        public int PropertyId { get; set; }
        public string Property { get; set; }
        public decimal ApartTarif { get; set; }
        public string PrtyCategory { get; set; }
    }
}
