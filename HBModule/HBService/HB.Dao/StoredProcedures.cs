using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Dao
{
    public class StoredProcedures
    {
        //MenuScreen
        public const string MenuScreen_Help = "Sp_MenuScreen_Help";

        //ImportExcel
        public const string Excel_Insert = "Sp_ExcelProperty_Insert";


        //PropertyAgrreementRoomChrges
        public const string PropertyAgreementRoomCharges_Insert = "Sp_PrptyAgremntRoomCharges_Insert";
        public const string PropertyAgreementRoomCharges_Update = "Sp_PrptyAgremntRoomCharges_Update";

        //PropertyAgreementOwner
        public const string PropertyAgreementOwner_Insert = "sp_PropertyAgreementsOwner_Insert";
        public const string PropertyAgreementOwner_Update = "sp_PropertyAgreementsOwner_Update";


        //Roles
        public const string UserRoles_Insert = "sp_UserRoles_Insert";
        public const string UserRoles_Update = "sp_UserRoles_Update";

        //UserMaster
        public const string UserMaster_Insert = "sp_usermasterinsert";
        public const string UserMaster_Update = "sp_usermasterupdate";
        public const string UserMaster_Delete = "sp_usermasterdelete";
        public const string UserMaster_Select = "sp_usermasterselect";
        public const string UserMaster_Help   = "sp_usermasterhelp";

        //ScreenMaster
        public const string ScreenMaster_insert = "sp_ScreenMaster_insert";
        public const string ScreenMaster_update = "sp_ScreenMaster_update";
        public const string ScreenMaster_delete = "sp_ScreenMaster_delete";
        public const string ScreenMaster_select = "sp_ScreenMaster_select";
        public const string ScreenMaster_help = "sp_ScreenMaster_help";



        //Locality
        // public const string Locality_Help = "SP_Locality_Help";
        //public const string Locality_Insert = "SP_Locality_Insert";
        //public const string Locality_Update = "SP_Locality_Update";
        //public const string Locality_Select = "SP_Locality_Select";
        //public const string Locality_Delete = "SP_Locality_Delete";
        //Property
      

        public const string Property_Insert = "Sp_Property_Insert";
        public const string Property_Update = "Sp_Property_Update";
        public const string PropertyUsers_Insert = "Sp_PropertyUsers_Insert";
        public const string PropertyUsers_Update = "Sp_PropertyUsers_Update";
        public const string PropertyImages_Update = "Sp_PropertyImages_Update";
        public const string PropertyImages_Insert = "Sp_PropertyImages_Insert";
        public const string Property_Select = "sp_Property_Select";
        public const string Property_Delete = "Sp_Property_Delete";
        public const string Property_Help = "sp_Property_Help";

        public const string PropertyBlock_Insert = "Sp_PropertyBlock_Insert";
        public const string PropertyBlock_Update = "Sp_PropertyBlock_Update";

        public const string PropertyRooms_Update ="Sp_PropertyRooms_Update";
        public const string PropertyRooms_Insert = "Sp_PropertyRooms_Insert";
        public const string PropertyRooms_Help    = "Sp_PropertyRooms_Help";
        public const string PropertyRooms_Select  = "Sp_PropertyRooms_Select";
        public const string PropertyRooms_Delete  = "Sp_PropertyRooms_Delete";


        public const string PropertyRoomBeds_Insert = "Sp_PropertyRoomBeds_Insert";
        public const string PropertyRoomBeds_Update = "Sp_PropertyRoomBeds_Update";
        public const string PropertyRoomBeds_Select = "Sp_PropertyRoomBeds_Select"; 
        public const string PropertyRoomBeds_Help   = "Sp_PropertyRoomBeds_Help";
        public const string PropertyRoomBeds_Delete = "Sp_PropertyRoomBeds_Delete";



        public const string Apartment_Update = "Sp_Apartment_Update";
        public const string Apartment_Insert = "Sp_Apartment_Insert";
        public const string Apartment_Select = "Sp_Apartment_Select";
        public const string Apartment_Delete = "Sp_Apartment_Delete";
        public const string Apartment_Help   = "Sp_Apartment_Help";


        public const string  PropertyOwner_Insert               = "sp_PropertyOwner_Insert";
        public const string  PropertyOwner_Update               = "sp_PropertyOwner_Update"; 
        public const string  PropertyOwnerApartment_Insert      = "sp_PropertyOwnerApartment_Insert";
        public const string  PropertyOwnerApartment_Update      = "sp_PropertyOwnerApartment_Update";
        public const string  PropertyOwnerOthersContacts_Insert = "sp_PropertyOwnerOthersContacts_Insert";
        public const string  PropertyOwnerOthersContacts_Update = "sp_PropertyOwnerOthersContacts_Update";
        public const string  PropertyOwner_Select               = "sp_PropertyOwner_Select";
        public const string  PropertyOwner_Delete               = "sp_PropertyOwner_Delete";
        public const string  PropertyOwner_Help                 = "sp_PropertyOwner_Help";

        public const string  PropertyAgreement_Insert = "sp_PropertyAgreement_Insert";
        public const string  PropertyAgreement_Update = "sp_PropertyAgreement_Update";
        public const string  PropertyAgreement_Select = "sp_PropertyAgreement_Select";
        public const string  PropertyAgreement_Delete = "sp_PropertyAgreement_Delete";
        public const string  PropertyAgreement_Help   = "sp_PropertyAgreement_Help";
        public const string PropertyAgreementDetails_Insert = "sp_PropertyAgreementDetails_Insert";
        public const string PropertyAgreementDetails_Update = "sp_PropertyAgreementDetails_Update";


        public const string Roles_Insert = "sp_Roles_Insert";
        public const string Roles_Update = "sp_Roles_Update";
        public const string Roles_Select = "sp_Roles_Select";
        public const string Roles_Delete = "sp_Roles_Delete";
        public const string Roles_Help = "sp_Roles_Help";

       
        public const string RolesDetails_Insert = "sp_RolesRights_Insert";
        public const string RolesDetails_Update = "sp_RolesRights_Update";
        //public const string Roles_Select = "sp_RolesRights_Select";
       
       
        // Client Management
        public const string ClientManagement_Help   = "SP_ClientManagement_Help";
        public const string ClientManagement_Insert = "SP_ClientManagement_Insert";
        public const string ClientManagement_Update = "SP_ClientManagement_Update";
        public const string ClientManagement_Select = "SP_ClientManagement_Select";
        public const string ClientManagement_Delete = "SP_ClientManagement_Delete";
        //ClientDeatils
        public const string ClientMgntAddNewClient_Insert = "sp_ClientManagementAddNewClient_Insert";
        public const string ClientMgntAddNewClient_Update = "sp_ClientManagementAddNewClient_Update";
        public const string ClientMgntClientguest_Insert = "sp_ClientManagementAddClientGuest_Insert";
        public const string ClientMgntClientguest_Update = "sp_ClientManagementAddClientGuest_Update";
        public const string ClientMgntCustomFields_Insert = "sp_ClientManagementCustomFields_Insert";
        public const string ClientMgntCustomFields_Update = "sp_ClientManagementCustomFields_Update";


        //City
        public const string City_Help = "SP_City_Help";
        public const string City_Insert = "SP_City_Insert";
        public const string City_Update = "SP_City_Update";
        public const string City_Select = "SP_City_Select";
        public const string City_Delete = "SP_City_Delete";

        //CityLocality
        public const string Citylocality_Help = "SP_Locality_Help";
        public const string Citylocality_Insert = "SP_Locality_Insert";
        public const string Citylocality_Update = "SP_Locality_Update";
        public const string Citylocality_Select = "SP_Locality_Select";
        public const string Citylocality_Delete = "SP_Locality_Delete";

        //ClientGradeCity
        public const string ClientGradeCity_Insert = "Sp_ClientGradeValue_Insert";
        public const string ClientGradeCity_Update = "Sp_ClientGradeValue_Update";
        public const string ClientGradeCity_Select = "sp_ClientGradeValue_Select";
        public const string ClientGradeCity_Help = "Sp_ClientGradeValue_Help";
        public const string ClientGradeCity_Delete = "sp_ClientGradeValue_Delete";

        public const string ClientGradeCityDetails_Insert = "Sp_ClientGradeValueDetails_Insert";
        public const string ClientGradeCityDetails_Update = "Sp_ClientGradeValueDetails_Update";


        //ContractManagement
        public const string ContractManagement_Insert = "Sp_ContractManagement_Insert";
        public const string ContractManagement_Update = "Sp_ContractManagement_Update";
        public const string ContractManagement_Select = "Sp_ContractManagement_Select";
        public const string ContractManagement_Delete = "Sp_ContractManagement_Delete";
        public const string ContractManagement_Help   = "Sp_ContractManagement_Help";  
        //Contract Tariff
        //  public const string ContractManagementTariff_Insert = "Sp_ContractManagementTariff_Insert";
        // public const string ContractManagementTariff_Update = "Sp_ContractManagementTariff_Update";

        //ContractManagementTariffAppartment
        public const string ContractManagementTariffAppartment_Insert = "Sp_ContractManagementTariffAppartment_Insert";
        public const string ContractManagementTariffAppartment_Update = "Sp_ContractManagementTariffAppartment_Update";

        //Contract Services
        public const string ContractManagementServices_Insert = "Sp_ContractManagementServices_Insert";
        public const string ContractManagementServices_Update = "Sp_ContractManagementServices_Update";

        //ContractProductMaster
        public const string ContractProductMaster_Insert = "Sp_ContractProductMaster_Insert";
        public const string ContractProductMaster_Update = "Sp_ContractProductMaster_Update";
        public const string ContractProductMaster_Delete = "Sp_ContractProductMaster_Delete";
        public const string ContractProductMaster_Help = "Sp_ContractProductMaster_Help";
        public const string ContractProductMaster_Select = "Sp_ContractProductMaster_Select";

        // Client Management
        public const string MasterClientManagement_Help = "SP_MasterClientManagement_Help";
        public const string MasterClientManagement_Insert = "SP_MasterClientManagement_Insert";
        public const string MasterClientManagement_Update = "SP_MasterClientManagement_Update";
        public const string MasterClientManagement_Select = "SP_MasterClientManagement_Select";
        public const string MasterClientManagement_Delete = "SP_MasterClientManagement_Delete";

        //ContractManageMentNondedicated
        public const string ContractNonDedicated_Insert = "SP_ContractNonDedicated_Insert";
        public const string ContractNonDedicated_Update = "SP_ContractNonDedicated_Update";
        public const string ContractNonDedicated_Delete = "SP_ContractNonDedicated_Delete";
        public const string ContractNonDedicated_Help = "SP_ContractNonDedicated_Help";
        public const string ContractNonDedicated_Select = "SP_ContractNonDedicated_Select";

        //ContractManageMentNondedicatedApartment
        public const string ContractNonDedicatedApartment_Insert = "SP_ContractNonDedicatedApartment_Insert";
        public const string ContractNonDedicatedApartment_Update = "SP_ContractNonDedicatedApartment_Update";
      
        //ContractManageMentNondedicatedServices
        public const string ContractNonDedicatedServices_Insert = "SP_ContractNonDedicatedServices_Insert";
        public const string ContractNonDedicatedServices_Update = "SP_ContractNonDedicatedServices_Update";

        //ContractClientpreferHdr
        public const string ContractClientpreferHdr_Insert = "Sp_ContractClientPref_Header_Insert";
        public const string ContractClientpreferHdr_Update = "Sp_ContractClientPref_Header_Update";
        public const string ContractClientprefer_Delete = "Sp_ContractClientPref_Delete";
        public const string ContractClientprefer_Help = "Sp_ContractClientPref_Help";
        public const string ContractClientprefer_Select = "Sp_ContractClientPref_Select";

        //ContractClientpreferDtl
        public const string ContractClientpreferDtl_Insert = "Sp_ContractClientPref_Detail_Insert";
        public const string ContractClientpreferDtl_Update = "Sp_ContractClientPref_Detail_Update";


        //TransSubsPriceModel
        public const string TransSubsPriceModel_Insert = "Sp_TransSubsPriceModel_Insert";
        public const string TransSubsPriceModel_Update = "Sp_TransSubsPriceModel_Update";
        //public const string TransSubsPriceModel_Delete = "Sp_TransSubsPriceModel_Delete";
        public const string TransSubsPriceModel_Help = "Sp_TransSubsPriceModel_Help";
        public const string TransSubsPriceModel_Select = "Sp_TransSubsPriceModel_Select";

        // SSPCodeGeneration
        public const string SSPCodeGeneration_Help = "SP_SSPCodeGeneration_Help";
        public const string SSPCodeGeneration_Select = "Sp_SSPCodeGeneration_Select";
        public const string SSPCodeGeneration_Delete = "Sp_SSPCodeGeneration_Delete";
        public const string SSPCodeGeneration_Insert = "Sp_SSPCodeGeneration_Insert";
        public const string SSPCodeGeneration_Update = "Sp_SSPCodeGeneration_Update";
        public const string SSPCodeGenerationApartment_Insert = "Sp_SSPCodeGenerationApartment_Insert";
        public const string SSPCodeGenerationApartment_Update = "Sp_SSPCodeGenerationApartment_Update";
        public const string SSPCodeGenerationRooms_Insert = "Sp_SSPCodeGenerationRooms_Insert";
        public const string SSPCodeGenerationRooms_Update = "Sp_SSPCodeGenerationRooms_Update";
        public const string SSPCodeGenerationServices_Insert = "Sp_SSPCodeGenerationServices_Insert";
        public const string SSPCodeGenerationServices_Update = "Sp_SSPCodeGenerationServices_Update";

        // PettyCash
        public const string PettyCashHdr_Insert = "Sp_PettyCashHdr_Insert";
        public const string PettyCashHdr_Update = "Sp_PettyCashHdr_Update";
        public const string PettyCashHdr_Select = "Sp_PettyCashHdr_Select";
        public const string PettyCashHdr_Help = "Sp_PettyCashHdr_Help";
        public const string PettyCash_Delete = "Sp_PettyCash_Delete";
       


        // PettyCash
        public const string PettyCash_Insert = "Sp_PettyCash_Insert";
        public const string PettyCash_Update = "Sp_PettyCash_Update";
        public const string PettyCash_Help = "Sp_PettyCash_Help";
       

       //Petty Cash Status
        public const string PettyCashStatus_Help = "Sp_PettyCashStatus_Help";
        public const string PettyCashStatus_Update = "Sp_PettyCashStatus_Update";
        public const string PettyCashStatus_Select = "Sp_PettyCashStatus_Select";
        public const string PettyCashStatus_Insert = "Sp_PettyCashStatus_Insert";

        //Import Guest Excel
        public const string ImportGuest_Insert = "Sp_ImportGuest_Insert";
        public const string ImportGuest_Select = "Sp_ImportGrid_Select";
        public const string ImportGuest_Update = "Sp_ImportGuest_Update";
        public const string ImportGuest_Help = "Sp_ImportGuest_Help";

        //TaxMaster
        public const string TaxMaster_Insert = "Sp_TaxMaster_Insert";
        public const string TaxMaster_Update = "Sp_TaxMaster_Update";
        public const string TaxMaster_Help = "Sp_TaxMaster_Help";

       //ReassignClient
        public const string ReassignClient_Update = "Sp_ReassignClient_Update";
        public const string ReassignClient_Help = "Sp_ReassignClient_Help";

        //ReassignClientDtl
        public const string ReassignClientDtl_Update = "Sp_ReassignClientDtl_Update";

        //ReassignProperty
        public const string ReassignProperty_Update = "Sp_ReassignProperty_Update";

        //ReassignPropertyDtl
        public const string ReassignPropertyDtl_Update = "Sp_ReassignPropertyDtl_Update";

       //CompanyMaster
        public const string CompanyMaster_Insert = "Sp_CompanyMaster_Insert";
        public const string CompanyMaster_Update = "Sp_CompanyMaster_Update";
        public const string CompanyMaster_Help = "Sp_CompanyMaster_Help";
        public const string CompanyMaster_Select = "Sp_CompanyMaster_Select";
        public const string CompanyMaster_Delete = "Sp_CompanyMaster_Delete";

        //AddUser
        public const string AddUser_Insert = "Sp_Registration_Insert";
        public const string AddUser_Update = "Sp_Registration_Update";
        public const string AddUser_Help = "Sp_Registration_Help";
        public const string AddUser_Select = "Sp_Registration_Select";
        public const string AddUser_Delete = "Sp_Registration_Delete";

        //AddUser
        public const string Forgot_Select = "Sp_Forgot_Select";

       //Guest Check In
        public const string CheckInHdr_Insert = "SP_CheckInHdr_Insert";
        public const string CheckInDtls_Insert = "SP_CheckInDtls_Insert";
        public const string CheckInHdr_Update = "SP_CheckInHdr_Update";
        public const string CheckInDtls_Update = "SP_CheckInDtls_Update";
        public const string CheckIn_Help = "Sp_CheckIn_Help";
        public const string CheckInDtls_Help = "Sp_CheckInDtls_Help";
        public const string CheckIn_Select = "SP_CheckIn_Select";
        
       //SlabTax
        public const string SlabTax_Insert = "Sp_SlabTax_Insert";
        public const string SlabTax_Update = "Sp_SlabTax_Update";
        public const string SlabTax_Delete = "Sp_SlabTax_Delete";
        public const string SlabTax_Select = "Sp_SlabTax_Select";

      //TIA and NTIA
        public const string TIA_Insert = "Sp_TiaAndATia_Insert";
        public const string TIA_Update = "Sp_TiaAndATia_Update";
        public const string TIA_Delete = "Sp_TiaAndATia_Delete";
        public const string TIA_Help = "Sp_TiaAndATia_Help";
        public const string TIA_Select = "Sp_TiaAndATia_Select";

    //TDS Declaration
        public const string TDS_Insert = "Sp_TDSDeclaration_Insert";
        public const string TDS_Update = "Sp_TDSDeclaration_Update";
        public const string TDS_Delete = "Sp_TDSDeclaration_Delete";
        public const string TDS_Help = "Sp_TDSDeclaration_Help";
        public const string TDS_Select = "Sp_TDSDeclaration_Select";

        //Guest CheckOut
        public const string CheckOutHdr_Insert = "SP_CheckOutHdr_Insert";
        public const string CheckOutHdr_Update = "SP_CheckOutHdr_Update";
        public const string CheckOut_Select = "SP_CheckOut_Select";
        public const string Checkout_Help = "Sp_Checkout_Help";
        public const string CheckOut_Delete = "SP_CheckOut_Delete";
        //EXTERNAL CHECKOUT
        public const string ExterCheckOutHdr_Insert = "SP_ExterCheckOutHdr_Insert";
        public const string ExternalCheckout_Help = "Sp_ExternalCheckout_Help";
        //EXTERNAL CHECKOUT TAC
        public const string ExternalCheckoutTAC_Help = "Sp_ExternalCheckoutTAC_Help";

       //KOTEntry Header and Details
        public const string KOT_Help = "Sp_KOT_Help";
        public const string KOTEntryHdr_Insert = "SP_KOTEntryHdr_Insert";
        public const string KOTEntryHdr_Update = "SP_KOTEntryHdr_Update";
        public const string KOTEntryDtls_Insert = "SP_KOTEntryDtls_Insert";
        public const string KOTEntryDtls_Update = "SP_KOTEntryDtls_Update";
        public const string KOTEntryUser_Insert = "SP_KOTEntryUser_Insert";
        public const string KOTEntryUser_Update = "SP_KOTEntryUser_Update";
        public const string KOTEnrty_Select = "SP_KOTEnrty_Select";
        public const string KOTEntry_Delete = "Sp_KOTEntry_Delete";

       //MarkUp
        public const string MarkUp_Insert = "Sp_MarkUp_Insert";
        public const string MarkUp_Select = "Sp_MarkUp_Select";
        public const string MarkUp_Delete = "Sp_MarkUp_delete";
        public const string MarkUp_Help = "Sp_MarkUp_Help";

        //MMT Markup
        public const string MMTMarkup_Insert = "Sp_MMTMarkUp_Insert";


        //Guest CheckOutServiceHdr(Internal Property)
        public const string CheckOutHdrService_Insert = "SP_CheckOutServiceHdr_Insert";
        public const string CheckOutHdrService_Update = "SP_CheckOutServiceHdr_Update";
        public const string CheckOutHdrService_Select = "SP_CheckOutServiceHdr_Select";
        public const string CheckOutHdrService_Help = "Sp_CheckoutService_Help";

        //Guest CheckOutServiceDtl
        public const string CheckOutHdrServiceDtl_Insert = "SP_CheckOutServiceDtl_Insert";
        public const string CheckOutHdrServiceDtl_Update = "SP_CheckOutServiceDtl_Update";
        public const string CheckOutHdrServiceDtl_Select = "SP_CheckOutServiceDtl_Select";

       

        //NewKOTEntry Header
        public const string NewKOT_Help = "Sp_NewKOTEntry_Help";
        public const string NewKOTEntryHdr_Insert = "SP_NewKOTEntryHdr_Insert";
        public const string NewKOTEntryHdr_Update = "SP_NewKOTEntryHdr_Update";
        public const string NewKOTEnrtyHdr_Select = "SP_NewKOTEntryHdr_Select";
        public const string NewKOTEntry_Delete = "Sp_NewKOTEntryHdr_Delete";
        //public const string KOTEntryDtls_Insert = "SP_KOTEntryDtls_Insert";
        //public const string KOTEntryDtls_Update = "SP_KOTEntryDtls_Update";
        public const string NewKOTEntryDtl_Insert = "SP_NewKOTEntryDtl_Insert";
        public const string NewKOTEntryDtl_Update = "SP_NewKOTEntryDtl_Update";



       //BookingCancel

        public const string BookingCancel_Help = "SP_BookingCancel_Help";
        public const string BookingPropertyAssingedGuest_Update = "SP_BookingPropertyAssingedGuest_Update";

        //Guest CheckOutServiceHdr
        public const string CheckOutHdrSettleHdr_Insert = "SP_CheckOutSettleHdr_Insert";
        public const string CheckOutHdrSettleHdr_Update = "SP_CheckOutSettleHdr_Update";
        //Guest CheckOutServiceDtl
        public const string CheckOutHdrSettleDtl_Insert = "SP_CheckOutSettleDtl_Insert";
        public const string CheckOutHdrSettleDtl_Update = "SP_CheckOutSettleDtl_Update";

        // GUEST CHECKOUT PAYMENT
        public const string CheckOutPayment_Insert = "SP_CheckOutPayment_Insert";
        public const string CheckOutPayment_Update = "SP_CheckOutPayment_Update";

       //Print Report 
        public const string GuestCheckOutTariff_Bill = "SP_GuestCheckOutTariff_Bill";
        public const string GuestCheckOutService_Bill = "SP_GuestCheckOutService_Bill";
        public const string GuestCheckOutConsolidate_Bill = "SP_GuestCheckOutConsolidate_Bill";
        public const string NewSnackKOT_Bill = "SP_NewSnackKOT_Bill";

        // Room Level Booking
        public const string Booking_Help = "SP_Booking_Help";
        public const string BookingDtls_Help = "SP_BookingDtls_Help";
        public const string Booking_Select = "Sp_Booking_Select";
        public const string Booking_Delete = "Sp_Booking_Delete";
        public const string Booking_Insert = "Sp_Booking_Insert";
        public const string Booking_Update = "Sp_Booking_Update";
        public const string BookingCustomFieldsDetails_Insert = "Sp_BookingCustomFieldsDetails_Insert";
        public const string BookingCustomFieldsDetails_Update = "Sp_BookingCustomFieldsDetails_Update";
        public const string BookingGuestDetails_Insert = "Sp_BookingGuestDetails_Insert";
        public const string BookingGuestDetails_Update = "Sp_BookingGuestDetails_Update";
        public const string BookingProperty_Update = "SP_BookingProperty_Update";
        public const string BookingProperty_Insert = "SP_BookingProperty_Insert";
        public const string BookingPropertyAssingedGuest_Insert = "SP_BookingPropertyAssingedGuest_Insert";

        // Bed Level Booking
        public const string BedBookingPropertyAssingedGuest_Insert = "SP_BedBookingPropertyAssingedGuest_Insert";
        public const string BedBookingProperty_Insert = "SP_BedBookingProperty_Insert";
        public const string BedBooking_Help = "SP_BedBooking_Help";

        // Apartment Level Booking
        public const string ApartmentBookingPropertyAssingedGuest_Insert = "SP_ApartmentBookingPropertyAssingedGuest_Insert";
        public const string ApartmentBookingProperty_Insert = "SP_ApartmentBookingProperty_Insert";
        public const string ApartmentBooking_Help = "SP_ApartmentBooking_Help";


        //SP_PettyCashRequired_Help
        public const string PettyCashRequired_Help = "SP_PettyCashRequired_Help";

        //PettyCashRequested
        public const string PettyCashApprovalHdr_Help = "SP_PettyCashApprovalHdr_Help";
        public const string PettyCashApprovalHdr_Insert = "SP_PettyCashApprovalHdr_Insert";
        public const string PettyCashApprovalHdr_Update = "SP_PettyCashApprovalHdr_Update";
        public const string PettyCashApprovalDtl_Insert = "SP_PettyCashApprovalDtl_Insert";
        public const string PettyCashApprovalDtl_Update = "SP_PettyCashApprovalDtl_Update";


        //Flex Report 
        public const string Report_Help = "SP_Report_Help";
        public const string BookingAndCheckInReport_Help = "SP_ReportForeCast_Help";
        public const string ReportRentANDMaintenance_Help = "SP_ReportRentANDMaintenance_Help";
        public const string InvoiceBill_Help = "SP_InvoiceBill_Help";
        

       //ExpenseMaster
        public const string ExpenseMaster_Insert = "Sp_ExpenseMaster_Insert";
        public const string ExpenseMaster_Update = "Sp_ExpenseMaster_Update";
        public const string ExpenseMaster_Help = "Sp_ExpenseMaster_Help";
        public const string ExpenseMaster_Select = "Sp_ExpenseMaster_Select";

        //PettyCashReport
        public const string PettyCashReport_Help = "Sp_PettyCashreport_Help";

        //PCHistory
        public const string PCHistory_Help = "SP_PCHistoryReport_Help";


        //PCHistory
        public const string NewSnackKOTEntryReport_Help = "SP_NewSnackKOTEntryReport_Help";

        //Import Bank Statement
        public const string BankStatement_Insert = "Sp_BankTransaction_Insert";

        //Guest Check Out Payment
           // Cash
        public const string CheckOutPaymentCash_Insert = "SP_CheckOutPaymentCash_Insert";
        public const string CheckOutPaymentCash_Update = "SP_CheckOutPaymentCash_Update";
           //Card
        public const string CheckOutPaymentCard_Insert = "SP_CheckOutPaymentCard_Insert";
        public const string CheckOutPaymentCard_Update = "SP_CheckOutPaymentCard_Update";
            //Company Invoice
        public const string CheckOutPaymentCompanyInvoice_Insert = "SP_CheckOutPaymentCompanyInvoice_Insert";
        public const string CheckOutPaymentCompanyInvoice_Update = "SP_CheckOutPaymentCompanyInvoice_Update";
           //Cheque
        public const string CheckOutPaymentCheque_Insert = "SP_CheckOutPaymentCheque_Insert";
        public const string CheckOutPaymentCheque_Update = "SP_CheckOutPaymentCheque_Update";
           // NEFT
        public const string CheckOutPaymentNEFT_Insert = "SP_CheckOutPaymentNEFT_Insert";
        public const string CheckOutPaymentNEFT_Update = "SP_CheckOutPaymentNEFT_Update";


        //Deposit
        public const string Deposit_Insert = "Sp_Deposit_Insert";
        public const string Deposit_Help = "Sp_Deposit_Help";
        public const string Deposit_Search = "Sp_Deposite_Select";

        public const string DtlDeposit_Insert = "Sp_DepositDtls_Insert";
        //PCHistory
        public const string NewSnackKOTEntryHistory_Help = "SP_NewSnackKOTEntryHistory_Help";

        //ClientWisePriceModel
        public const string ClientWisePrice_Insert = "Sp_ClientWisePricingModel_Insert";
        public const string ClientWisePrice_Help = "Sp_ClientWisePricingModel_Help";
        public const string ClientWisePrice_Update = "Sp_ClientWisePricingModel_Update";

        //PCHistory
        public const string SnackKOTHistory_Help = "SP_SnackKOTHistory_Help"; 


        public const string Vendor_Update = "Sp_Vendor_Update";
        public const string Vendor_Insert = "Sp_Vendor_Insert";
        public const string Vendor_Delete = "Sp_Vendor_Delete";
        public const string Vendor_Select = "Sp_Vendor_Select";
        public const string Vendor_Help = "Sp_Vendor_Help";

        //PaxInOut
        public const string PaxInOut_Update = "Sp_PaxInOut_Update";
        public const string PaxInOut_Insert = "Sp_PaxInOut_Insert";
        public const string PaxInOut_Select = "Sp_PaxInOut_Select";
        public const string PaxInOut_Help = "Sp_PaxInOut_Help"; 

        //Room Shift
        public const string RoomShift_Help = "Sp_RoomShift_Help"; 


        //MapVendor
        public const string MapVendor_Update = "Sp_MapVendor_Update";
        public const string MapVendor_Insert = "Sp_MapVendor_Insert";
        public const string MapVendor_Help = "Sp_MapVendor_Help";

        //VendorCost
        public const string VendorCost_Update = "Sp_VendorCost_Update";
        public const string VendorCost_Insert = "Sp_VendorCost_Insert";
        public const string VendorCost_Help = "Sp_VendorCost_Help";

        //TravelDesk
        public const string TravelDesk_Update = "Sp_TravelDesk_Update";
        public const string TravelDesk_Insert = "Sp_TravelDesk_Insert";
        public const string TravelDesk_Delete = "Sp_TravelDesk_Delete";
        public const string TravelDesk_Select = "Sp_TravelDesk_Select";
        public const string TravelDesk_Help   = "Sp_TravelDesk_Help";

        //TravelDesk
        public const string TravelAgency_Update = "Sp_TravelAgency_Update";
        public const string TravelAgency_Insert = "Sp_TravelAgency_Insert"; 

        //NewKOTVendorReport
        public const string NewKOTVendorReport_Help = "Sp_KOTVendorReport_Help";

        //PettyCashRequested
        public const string VendorChequeApprovalHdr_Help = "SP_VendorChequeApprovalHdr_Help";
        public const string VendorChequeApprovalHdr_Insert = "SP_VendorChequeApprovalHdr_Insert";
        public const string VendorChequeApprovalHdr_Update = "SP_VendorChequeApprovalHdr_Update";
        public const string VendorChequeApprovalDtl_Insert = "SP_VendorChequeApprovalDtl_Insert";
        public const string VendorChequeApprovalDtl_Update = "SP_VendorChequeApprovalDtl_Update";

        //SearchBooking
        public const string SearchBooking_Help = "Sp_SearchBooking_Help";
        public const string SearchBooking_Search = "Sp_SearchBooking_Search";

        //Search Booking Guest
        public const string SearchBookingGuest_Help = "Sp_SearchBookingGuest_Help";
        public const string SearchBookingGuest_Search = "Sp_SearchBookingGuest_Search";


        //Clone Client Prefered
        public const string CloneClientPref_Help = "Sp_CloneClientPref_Help";
        public const string CloneClientPref_Insert = "Sp_CloneClientPref_Insert";
              
        // Room Shifting
        public const string RoomShifting_Help = "SP_RoomShifting_Help";
        public const string RoomShifting_Insert = "SP_RoomShifting_Insert";

        // Booking Mail Resend
        public const string BookingMailResend_Help = "SP_BookingMailResend_Help";

        //Payment Company invoice update
  //      public const string CheckOutPaymentCompanyInvoice_Update = "SP_CheckOutPaymentCompanyInvoice_Update";
        //External CheckOutTAC
        public const string ExterCheckOutTAC_Insert = "SP_ExterCheckOutTAC_Insert";
        
        
        //TAC Invoice Report
        public const string TACInvoice_Search = "Sp_TACInvoice_Search";
        public const string TACInvoice_Help = "Sp_TACInvoice_Help";
        
        //TRLink
        public const string TRLink_Insert = "Sp_TRLink_Insert";
        public const string TRLink_Help = "Sp_TRLink_Help";

        public const string TariffBasedReport = "Sp_TariffBasedReports";

        // Reports
        public const string Reports_Help = "SP_Reports_Help";

        //NewKOTEntry Header
       // public const string NewKOT_Help = "Sp_NewKOTUserEntry_Help";
        public const string NewKOTUserEntryHdr_Insert = "SP_NewKOTUserEntryHdr_Insert";
        public const string NewKOTUserEntryHdr_Update = "SP_NewKOTUserEntryHdr_Update";
        public const string NewKOTUserEntryHdr_Select = "SP_NewKOTUserEntryHdr_Select";
        //public const string NewKOTEntry_Delete = "Sp_NewKOTUserEntryHdr_Delete";
        //public const string KOTEntryDtls_Insert = "SP_KOTEntryDtls_Insert";
        //public const string KOTEntryDtls_Update = "SP_KOTEntryDtls_Update";
        public const string NewKOTUserEntryDtl_Insert = "SP_NewKOTUserEntryDtl_Insert";
        public const string NewKOTUserEntryDtl_Update = "SP_NewKOTUserEntryDtl_Update";

        //OutsourceKOT Header
        public const string OutsourceKOTHdr_Help = "Sp_OutsourceKOTHdr_Help";
        public const string OutsourceKOTHdr_Insert = "SP_OutsourceKOTHdr_Insert";
        public const string OutsourceKOTHdr_Update = "SP_OutsourceKOTHdr_Update";
        public const string OutsourceKOTHdr_Select = "SP_OutsourceKOTHdr_Select";
        public const string OutsourceKOTDtl_Insert = "SP_OutsourceKOTDtl_Insert";
        public const string OutsourceKOTDtl_Update = "SP_OutsourceKOTDtl_Update";

        //Reconcile
        public const string Reconcile_Help   = "Sp_Reconcile_Help";
        public const string Reconcile_Select = "Sp_Reconcile_Select";
        public const string Reconcile_Insert = "Sp_Reconcile_Insert";
        public const string Reconcile_Update = "Sp_Reconcile_Update";

        // PettyCash
        public const string VendorRequest_Insert = "Sp_VendorRequest_Insert";
        public const string VendorRequest_Update = "Sp_VendorRequest_Update";
        public const string VendorRequest_Select = "Sp_VendorRequest_Select";
        public const string VendorRequest_Help = "Sp_VendorRequest_Help";
        public const string VendorRequest_Delete = "Sp_VendorRequest_Delete";

        //Contract Bill
        public const string ContractBill_Help = "Sp_ContractBill_Help";
        public const string ContractBill_Update = "Sp_ContractBill_Update";
        public const string ContractBill_Search = "Sp_ContractBill_Search";
        public const string ContractBill_Report = "SP_ContractBill_Report";

        //BTC Submission 
        public const string BTCSubmission_Help = "SP_BTCSubmission_Help";
        public const string BTCSubmission_Save = "SP_BTCSubmission_Save";
        public const string BTCSubmission_Update = "SP_BTCSubmission_Update";
        public const string BTCSubmission_Search = "Sp_BTCSubmission_Select";
        public const string BTCSubmission_Delete = "SP_BTCSubmission_Delete";

       // public const string BTCSubmissionDetails_Save = "SP_BTCSubmissionDetails_Save";
        //public const string BTCSubmissionDetails_Update = "SP_BTCSubmissionDetails_Update";

        public const string BTCSubmissionCash_Insert = "Sp_BTCSubmissionCash_Insert";
        public const string BTCSubmissionCard_Insert = "Sp_BTCSubmissionCard_Insert";
        public const string BTCSubmissionCheque_Insert = "Sp_BTCSubmissionCheque_Insert";
        public const string BTCSubmissionNEFT_Insert = "Sp_BTCSubmissionNEFT_Insert";

      //  public const string BTCSubmissionDetails_Insert = "Sp_BTCSubmissionModeDetail_Insert";


        // API
        public const string API_Help = "SP_API_Help";
        public const string APIHeader_Insert = "SP_APIHeader_Insert";
        public const string APIHotelHeader_Insert = "SP_APIHotelHeader_Insert";
        public const string APIRoomTypeDetails_Insert = "SP_APIRoomTypeDetails_Insert";
        public const string APIRateMealPlanInclusionDetails_Insert = "SP_APIRateMealPlanInclusionDetails_Insert";
        public const string APITariffDetails_Insert = "SP_APITariffDetails_Insert";
        public const string APIRoomRateDetails_Insert = "SP_APIRoomRateDetails_Insert";
        public const string APIPropertyDetails_Update = "SP_APIPropertyDetails_Update";


        //PCExpenseApproval
        public const string PCExpenseApproval_Help = "SP_PCExpenseApproval_Help";
        public const string PCExpenseApproval_Insert = "SP_PCExpenseApproval_Insert";
        public const string PCExpenseApproval_Update = "SP_PCExpenseApproval_Update";

        //Client Column
        public const string ClientColumn_Help = "Sp_ClientCloumn_Help";
        public const string ClientColumn_Insert = "Sp_ClientColumn_Insert";
        public const string ClientColumn_Update = "Sp_ClientColumn_update";    

        //Property Report
        public const string PropertyReport_Help = "Sp_SearchProperty_Help";
        public const string PropertyReport_Search = "Sp_SearchProperty_Search";

        //Map PO and Vendor
        public const string MapPOandVendor_Help = "Sp_MapVendorandPO_Report";
        public const string MapPOAndVendorPaymentHdr_Insert = "Sp_MapPOAndVendorPaymentHdr_Insert";
        public const string MapPOAndVendorPaymentDtls_Insert = "Sp_MapPOAndVendorPaymentDtls_Insert";

        //Export Unsettled
        public const string ExportUnsettled_Help = "Sp_ExportUnsettled_Help";
        public const string ExportUnsettled_Search = "Sp_ExportUnsettled_Search";


        //FormatReceipts
        public const string FormatReceipts_Help = "SP_ReceiptsFormats_Help";

        //NewKOTEntry Header
        public const string LaundryServiceHdr_Help = "SP_LaundryServiceHdr_Help";
        public const string LaundryServiceHdr_Insert = "SP_LaundryServiceHdr_Insert";
        public const string LaundryServiceHdr_Update = "SP_LaundryServiceHdr_Update";
        public const string LaundryServiceHdr_Select = "SP_LaundryServiceHdr_Select";
        public const string LaundryServiceHdr_Delete = "SP_LaundryServiceHdr_Delete";
        public const string LaundryServiceDtl_Insert = "SP_LaundryServiceDtl_Insert";
        public const string LaundryServiceDtl_Update = "SP_LaundryServiceDtl_Update";


         //ApprovedPC
        public const string ApprovedPettyCash_Update = "Sp_ApprovedPettyCash_Update";

        //Vendor Settlement
        public const string VendorSettlementTACInvoiceAmount_Insert = "Sp_VendorSettlementTACInvoiceAmount_Insert";
        public const string VendorSettlementInvoiceAmount_Insert = "Sp_VendorSettlementInvoiceAmount_Insert";
        public const string VendorSettlementAdjusmentAdvanceAmount_Insert = "Sp_VendorSettlementAdjusmentAdvanceAmount_Insert";
        public const string VendorSettlementPaidAmount_Insert = "Sp_VendorSettlementPaidAmount_Insert";

        //SearchInvoiceReport
        public const string SearchInvoiceReport_Help = "Sp_SearchInvoiceReport_Help";

        //InternalExpenseReport
        public const string InternalInvoiceReport_Help = "SP_InternalInvoiceReport_Help";

        //ExternalExpenseReport
        public const string ExternalInvoiceReport_Help = "SP_ExternalInvoiceReport_Help";

        //Vendor Settlement
        public const string VendorAdvancePayment_Insert = "Sp_VendorAdvancePayment_Insert";
        public const string VendorAdvancePayment_Update = "Sp_VendorAdvancePayment_Update";
        public const string VendorAdvancePayment_Select = "sp_VendorAdvancePayment_Select";

        //Vendor Settlement
        public const string TaxMapping_Insert = "Sp_TaxMapping_Insert";
        public const string TaxMapping_Update = "Sp_TaxMapping_Update";
        public const string TaxMapping_Help = "sp_TaxMapping_Help";

        //External CheckOutTAC MAil
        public const string ExternalCheckOutTariffMail_Report = "SP_ExternalCheckOutTariffMail_Report";

        public const string  PendingChkinReport_Help = "Sp_PendingChkinReport_Help"; 
       
        //CheckoutIntemediate
        public const string CheckoutIntermediate_Help = "Sp_CheckoutIntermediate_Help";
        public const string CheckoutIntermediate_Insert = "Sp_CheckoutIntermediate_Insert";
        //External CheckoutIntemediate
        public const string ExterInterCheckOutHdr_Insert = "SP_ExterInterCheckOutHdr_Insert";
        public const string ExterInterCheckOutTAC_Insert = "SP_ExterInterCheckOutTAC_Insert";
    //    public const string SP_IntermediateCheckOutConsolidate_Bill = "SP_IntermediateCheckOutConsolidate_Bill";

        //_TodaysCheckinChkout
        public const String TodaysCheckinChkout_Help = "Sp_TodaysCheckinChkout_Help";

        //Internal IntermediateReport
        public const string IntermediateCheckOutTariff_Bill = "SP_IntermediateCheckOutTariff_Bill";
        public const string IntermediateCheckOutService_Bill = "SP_IntermediateCheckOutService_Bill";
        public const string SP_IntermediateCheckOutConsolidate_Bill = "SP_IntermediateCheckOutConsolidate_Bill";
       
    }
}
