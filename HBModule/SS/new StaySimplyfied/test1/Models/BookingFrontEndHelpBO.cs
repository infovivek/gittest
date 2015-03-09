using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace test1.Models
{
    public class FrontHelpBO
    {
        public List<BookingFrontEndHelpBO> ManagedGuestHouse { get; set; }
        public List<BookingFrontEndHelpBO> ServiceAppartments { get; set; }
        public List<BookingFrontEndHelpBO> BudgetPrppertyList { get; set; }
        public List<BookingFrontEndHelpBO> BusinessPrppertyList { get; set; }
        public List<BookingFrontEndHelpBO> LuxuryPrppertyList { get; set; }
        public List<BookingFrontEndHelpBO> ClientPreferredPrppertyList { get; set; }
        public decimal? localityId { get; set; }
        public string propertyname { get; set; }
        public string rate { get; set; }
        public decimal? BedId { get; set; }
        public decimal? RoomId { get; set; }
        public string UserType { get; set; }
        public int? count { get; set; }
        public int? Roomcount { get; set; }
    }
    public class BookingFrontEndHelpBO
    {
        public decimal AvailableRoom { get; set; }
        public string Label2 { get; set; }
        public string Label3 { get; set; }
        public string Label1 { get; set; }
        public string BookingDetails { get; set; }
        public string Drop1Id { get; set; }
        public string Drop2Id { get; set; }
        public string Drop3Id { get; set; }
        public string LatitudeLangitude { get; set; }
        public string StarImage { get; set; }
        public string PropertyDiscription { get; set; }
        public decimal MinimunPrice { get; set; }
        public string AboutPpty { get; set; }
        public string dummy { get; set; }
        public string dummy2 { get; set; }
        public string PptyName { get; set; }
        public string PptyImg { get; set; }
        public Int64 PptyId { get; set; }
        public string GetType { get; set; }
        public string PropertyType { get; set; }
        public string RoomType { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Locality { get; set; }
        public string StarRating { get; set; }
        public string TaxAdded { get; set; }
        public string Inclusions { get; set; }
        public string Markup { get; set; }
        public string RatePlanCode { get; set; }
        public string RoomTypeCode { get; set; }
        public string MealPlan { get; set; }
        public string TripadvisorRating { get; set; }
        public decimal Display { get; set; }
        public string trbdrop1 { get; set; }
        public string trbdrop2 { get; set; }
        public string trbdrop3 { get; set; }
        public string trbdrop4 { get; set; }
        public string trbdrop5 { get; set; }
        public string trbdrop6 { get; set; }
        public string trbdrop7 { get; set; }
        public string trbdrop8 { get; set; }
        public string trbdrop9 { get; set; }
        public string trbdrop10 { get; set; }
        public string trrdrop1 { get; set; }
        public string trrdrop2 { get; set; }
        public string trrdrop3 { get; set; }
        public string trrdrop4 { get; set; }
        public string trrdrop5 { get; set; }
        public string trrdrop6 { get; set; }
        public string trrdrop7 { get; set; }
        public string trrdrop8 { get; set; }
        public string trrdrop9 { get; set; }
        public string trrdrop10 { get; set; }

        //public Int64 PID { get; set; }



        public decimal SingleTariff { get; set; }
        public decimal DoubleTariff { get; set; }
        public decimal TripleTariff { get; set; }
        public decimal SingleandMarkup { get; set; }
        public decimal DoubleandMarkup { get; set; }
        public decimal TripleandMarkup { get; set; }
        public decimal DiscountAllowed { get; set; }
        public decimal SingleandMarkup1 { get; set; }
        public decimal DoubleandMarkup1 { get; set; }
        public decimal TripleandMarkup1 { get; set; }
        public decimal STAgreed { get; set; }
        public decimal LTRack { get; set; }
        public decimal BaseTariff { get; set; }
        public decimal GeneralMarkup { get; set; }
        public decimal SC { get; set; }
        public decimal LTAgreed { get; set; }


        public bool TaxInclusive { get; set; }
        public bool DiscountModePer { get; set; }
        public bool DiscountModeRS { get; set; }
        public bool TAC { get; set; }

        public Int32 Tick { get; set; }
        public Int32 Chk { get; set; }
        public Int32 Id { get; set; }

        public Int64 APIHdrId { get; set; }
        public Int64 MarkupId { get; set; }
        public Int64 LocalityId { get; set; }

    }

    public class FrontEndHelpBO
    {
        public decimal SingleandMarkup { get; set; }
        public decimal DoubleandMarkup { get; set; }
        public decimal TripleandMarkup { get; set; }
        public string img { get; set; }
        public string roomtype { get; set; }
    }
}