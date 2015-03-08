using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace test1.Models
{
    public class APIDynamic
    {
        public Int32 HeaderId { get; set; }
        public string HotelId { get; set; }
        public string StarRating { get; set; }
        //public string RoomTypeName { get; set; }
        public string CityCode { get; set; }
        public string FrmDt { get; set; }
        public string ToDt { get; set; }
        // Tariff
        public Int32 RoomRateHdrId { get; set; }
        public string RoomTariffroomNumber { get; set; }
        public string Tarifftype { get; set; }
        public string Tariffgroup { get; set; }
        public decimal Tariffamount { get; set; }
        // Room Rate
        public string RoomRateroomTypeCode { get; set; }
        public string RoomRateratePlanCode { get; set; }
        public string RoomRateavailableCount { get; set; }
        public string RoomRateavailStatus { get; set; }
        // RatePlan
        public string RatePlanType { get; set; }
        public string RatePlanName { get; set; }
        public string RatePlanCode { get; set; }
        // inclusions
        public string InclusionStart { get; set; }
        public string InclusionEnd { get; set; }
        public string InclusionCode { get; set; }
        public string Inclusion { get; set; }
        // Meal Plan
        public string MealPlanCode { get; set; }
        public string MealPlan { get; set; }
        // Room Types
        public string RoomTypesstartDate { get; set; }
        public string RoomTypesendDate { get; set; }
        public string RoomTypesavailStatus { get; set; }
        public string RoomTypename { get; set; }
        public string RoomTypecode { get; set; }
        //
        public string Stats { get; set; }
        // create reservation
        public string AvaResponseReferenceKey { get; set; }
        public string BookResponseReferenceKey { get; set; }
        public string AvaResponseCode { get; set; }
        public string BookResponseCode { get; set; }
        public decimal AmountBeforeTax { get; set; }
        public decimal AmountAfterTax { get; set; }
        public int BookingId { get; set; }
        public string PtyRatePlancode { get; set; }
        public string PtyRoomTypecode { get; set; }
        public string start { get; set; }
        public string End { get; set; }
        public int singlecnt { get; set; }
        public int doublecnt { get; set; }
        public string AvaavailStatus { get; set; }
        public string BookReservationGlobalInfo { get; set; }
        public string BookHotelReservationIdvalue { get; set; }
        public string BookHotelReservationIdtype { get; set; }
        public string AvaRatePlanCode { get; set; }
        //
        public string GivenName { get; set; }
        public string NamePrefix { get; set; }
        public string Surname { get; set; }
        public string BookEmail { get; set; }
        //
        public string PenaltyDescription { get; set; }
    }
}