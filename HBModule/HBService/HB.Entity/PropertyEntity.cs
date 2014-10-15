using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PropertyEntity
    {
        public string PropertyName { get; set; }

        public string Code { get; set; }

        public string Category { get; set; }

        public string PropertDescription { get; set; }

        public string Prefix { get; set; }

        public decimal PropertyRackTarrif { get; set; }

        public string PropertyType { get; set; }

        public string Propertaddress { get; set; }

        public string TotalNoRooms { get; set; }

        public string City { get; set; }

        public string Localityarea { get; set; }

        public string State { get; set; }

        public string Postal { get; set; }

        public string Phone { get; set; }

        public string Directions { get; set; }

        public string Keyword { get; set; }

        public bool ServicesSwimPool { get; set; }

        public bool ServicesPub { get; set; }

        public bool ServicesGym { get; set; }

        public bool ServicesRestaurant { get; set; }

        public bool ServicesConfHall { get; set; }

        public bool ServicesCyberCafe { get; set; }

        public bool ServicesLaundry { get; set; }

        public bool ShowOnWebsite { get; set; }

        public string LatitudeLongitude { get; set; }

        public decimal RackTarrifDouble { get; set; }

        public string BookingPolicy { get; set; }

        public string CancelPolicy { get; set; }

        public string CreatedBy { get; set; }

        public int Id { get; set; }

        public string Date { get; set; }

        public int LocalityId { get; set; }

        public int CityId { get; set; }

        public int StateId { get; set; }

        public string Copy { get; set; }

        public int CopyId { get; set; }

        public string Email { get; set; }
        public int CheckIn { get; set; }
        public string CheckInType { get; set; }
        public int CheckOut { get; set; }
        public string CheckOutType { get; set; }
        public int GraceTime { get; set; }
    }
}
