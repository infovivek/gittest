using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class GuestCheckIn
    {
        //Header
        public int Id { get; set; }
        public int RoomId { get; set; }
        public int PropertyId { get; set; }
        public int StateId { get; set; }
        public int BookingId { get; set; }
        public int GuestId { get; set; }
        public string ChkInGuest { get; set; }
        public string CheckInNo { get; set; }
        public string ArrivalDate { get; set; }
        public string ArrivalTime { get; set; }
        public string ChkoutDate { get; set; }
        public string RoomNo { get; set; }
        public string GuestName { get; set; }
        public string ClientName { get; set; }
        public string Property { get; set; }
        public string MobileNo { get; set; }
        public string EmailId { get; set; }
        public string Designation { get; set; }
        public string Nationality { get; set; }
        public string IdProof { get; set; }
        public decimal ChkinAdvance { get; set; }
        public decimal Tariff { get; set; }
        public bool Direct { get; set; }
        public bool BTC { get; set; }
        public string Image { get; set; }
        public string EmpCode { get; set; }
        public string BookingCode { get; set; }
        public string TimeType { get; set; }
        public string Occupancy { get; set; }
        public decimal RackTariffSingle { get; set; }
        public decimal RackTariffDouble { get; set; }
        public int ApartmentId { get; set; }
        public int BedId { get; set; }
        public string ApartmentType { get; set; }
        public string BedType { get; set; }
        public string Type { get; set; }
        public string RefGuestId { get; set; }
        public string PropertyType { get; set; }
        public string CheckStatus { get; set; }
        public string GuestImage { get; set; }
        public decimal SingleMarkupAmount { get; set; }
        public decimal DoubleMarkupAmount { get; set; }
        public int ClientId { get; set; }
        public int CityId { get; set; }
        public int ServiceCharge { get; set; }

        // Details
        public int DtlsId { get; set; }
        public int HdrId { get; set; }
    }
}
