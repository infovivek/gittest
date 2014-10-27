using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.BusinessService.BusinessService;

namespace HB.BusinessService
{
    public class BusinessServiceFactory 
    {    
        private IBusinessService _businessService;
        public IBusinessService Create(string type)
        {
            switch (type)
            {
                case "ImportExcel":
                    _businessService = new ImportExcelService();
                    break;

                case "UserMaster":
                    _businessService = new UserMasterService();
                    break;
                case "City":
                    _businessService = new CityService();
                    break;
                case "Citylocality":
                    _businessService = new Citylocalityservice();
                    break;
                case "Locality":
                    _businessService = new LocalityService();
                    break;
                case "Property":
                    _businessService = new PropertyService();
                    break;
                case "PropertyImage":
                    _businessService = new PropertyImageService();
                    break;
                case "PropertyApartment":
                    _businessService = new ApartmentService();
                    break;
                case "PropertyRoom":
                    _businessService = new PropertyRoomService();
                    break;
                case "PropertyOwners":
                    _businessService = new PropertyOwnersService();
                    break;
                case "PropertyAgreement":
                    _businessService = new PropertyAgreementService();
                    break;
                case "ClientManagement":
                    _businessService = new ClientManagementService();
                    break;
                 case  "Roles":
                    _businessService = new RolesService();
                    break;
                case"ScreenMaster":
                    _businessService= new ScreenMasterService();
                    break;
                case "ClientGradeValue":
                    _businessService = new ClientGradeCityService();
                    break;
                case "ContractManagement":
                    _businessService = new ContractManagementService();
                    break;
                case "ContractNonDedicated":
                    _businessService = new ContractNonDedicatedService();
                    break;
                case "ContractProductMaster":
                    _businessService = new ContractProductMasterService();
                    break;
                case "ContractClientPrefer":
                    _businessService = new ContractClientPreferHdrService();
                    break;
                case "TransSubsPriceModel":
                    _businessService = new TransSubsPriceModelService();
                    break;
                case "MasterClientManagement":
                     _businessService = new MasterClientManagementService();
                    break;
                case "BOOKING":
                    _businessService = new BookingService();
                    break;
                case "BOOKINGDTLS":
                    _businessService = new BookingDtlsService();
                    break;
                case "BedBooking":
                    _businessService = new BedBookingService();
                    break;
                case "ApartmentBooking":
                    _businessService = new ApartmentBookingService();
                    break;
                case "BookingMail":
                    _businessService = new BookingMailService();
                    break;
                case "SSPCodeGeneration":
                    _businessService = new SSPCodeGenerationService();
                    break;
                //case "PettyCash":
                //    _businessService = new PettyCashService();
                //    break;
                case "PettyCashStatus":
                    _businessService = new PettyCashStatusService();
                    break;
                case "ImportGuest":
                    _businessService = new ImportGuestService();
                    break;
                case "Password":
                    _businessService = new ChangePasswordService();
                    break;
                case "MenuScreen":
                    _businessService = new MenuScreenService();
                    break;
                case "TaxMaster":
                    _businessService = new TaxMasterService();
                    break;
                case "ReassignClient":
                    _businessService = new ReassignClientService();
                    break;
                case "ReassignProperty":
                    _businessService = new ReassignPropertyService();
                    break;
                case "CompanyMaster":
                    _businessService = new CompanyMasterService();
                    break;
                case "AddUser":
                    _businessService = new AddUserService();
                    break;
                case "Forgot":
                    _businessService = new ForgotService();
                    break;
                case "GuestCheckIn":
                    _businessService = new GuestCheckInService();
                    break;
                case "GuestCheckInDtls":
                    _businessService = new GuestChkInDtlService();
                    break;

                case "SlabTax":
                    _businessService = new SlabTaxService();
                    break;

                case "TIAandNTIA":
                    _businessService = new TIAandATIAService();
                    break;

                case "TDSDeclaration":
                    _businessService = new TDSDeclarationService();
                    break;
                case "GuestCheckOut":
                    _businessService = new GuestCheckOutService();
                    break;
                case "KOTEntry":
                    _businessService = new KOTEntryService();
                    break;
                case "MarkUp":

                    _businessService = new MarkUpService();
                    break;
                case "CheckOutServiceHdr":
                    _businessService = new CheckOutServiceHdrService();
                    break;
                case "NewKOTEntry":
                    _businessService = new NewKOTEntryService();
                    break;
                case "BookingCancel":
                    _businessService = new BookingCancelService();
                    break;
                case "CheckOutSettleHdr":
                    _businessService = new CheckOutSettleService();
                    break;
                case "PettyCashRequiedStatus":
                    _businessService =  new PettyCashRequiedStatus();
                    break;
                case "PettyCashApproval":
                    _businessService = new PettyCashApprovalService();
                    break;
                case "Report":
                    _businessService = new ReportService();
                    break;
                case "ExpenseMaster":
                    _businessService = new ExpenseMasterService();
                    break;
                case "PettyCashReport":
                    _businessService = new PettyCashReportService();
                    break;
                case "CheckOutPayment":
                    _businessService = new CheckOutPaymentService();
                    break;
                case "PCHistory":
                    _businessService = new PCHistoryService();
                    break;
                case "NewSnackKOTReport":
                    _businessService = new NewSnackKOTReportService();
                    break;
                case "CheckOutPaymentCash":
                    _businessService = new CheckOutPaymentCashService();
                    break;
                case "CheckOutPaymentCard":
                    _businessService = new CheckOutPaymentCardService();
                    break;
                case "CheckOutPaymentCompInvoice":
                    _businessService = new CheckOutPaymentCompInvoiceService();
                    break;
                case "CheckOutPaymentCheque":
                    _businessService = new CheckOutPaymentChequeService();
                    break;
                case "CheckOutPaymentNEFT":
                    _businessService = new CheckOutPaymentNEFTService();
                    break;
                case "Deposit":
                    _businessService = new DepositService();
                    break;
                case "NewSnackKOTHistory":
                    _businessService = new NewSnackKOTHistoryService();
                    break;
                case "ClientWisePrice":
                    _businessService = new ClientWisePriceService();
                    break;
                case "SnackKOTHistory":
                    _businessService = new SnackKOTHistoryService();
                    break;
                case "Reconcile":
                    _businessService = new ReconcileService();
                    break;
                case "Vendors":
                    _businessService = new VendorService(); 
                    break;
                case "PaxInOut":
                    _businessService = new PaxInOutService();
                    break;
                case "MapVendor":
                    _businessService = new MapVendorService();
                    break;
                case "VendorCost":
                    _businessService = new VendorCostService();
                    break;
                case "TravelDesk":
                    _businessService = new TravelDeskService();
                    break;
                case "NewKOTVendorReport":
                    _businessService = new NewKOTVendorReportService();
                    break;
                case "VendorChequeApproval":
                    _businessService = new VendorChequeApprovalService();
                    break;
                case "ExternalCheckOut":
                    _businessService = new ExternalCheckOutService();
                    break;
                case "BookingSearch":
                    _businessService = new SearchBookingService();
                    break;
                case "CloneClientPrefer":
                    _businessService = new CloneClientService();
                    break;
                case "BookingResendMail":
                    _businessService = new BookingResendMailService();
                    break;
                case "RoomShifting":
                    _businessService = new RoomShiftingService();
                    break;
                case "TACInvoice":
                    _businessService = new TACInvoiceService();
                    break;
                case "TRLink":
                    _businessService = new TRLinkService();
                    break;
                case "TariffBasedReport":
                    _businessService= new TariffBasedReportService();
                   break;
                case "BookingSearchGuest":
                    _businessService=new SearchBookingGuestService();
                    break;
                case "Reports":
                    _businessService = new ReportsService();
                    break;
                case "NewKOTUserEntry":
                    _businessService = new NewKOTUserEntryService();
                    break;
                case "OutsourceKOTEntry":
                    _businessService = new OutsourceKOTService();
                    break;
                //case "Reconcile":
                //    _businessService = new ReconcileService();
                //    break;
                case "VendorRequest":
                    _businessService = new VendorRequestService();
                    break;
                case "ContractBill":
                    _businessService = new ContractBillService();
                    break;
                case "BTCSubmission":
                    _businessService = new BTCSubmissionService();
                    break;
                case "BTCPayment":
                    _businessService = new BTCPaymentService();
                    break;
                case "API":
                    _businessService = new APIService();
                    break;
                case "PCExpenseApproval":
                    _businessService = new PCExpenseApprovalService();
                    break;
                case "ClientColumn":
                    _businessService = new ClientColumnService();
                    break;
                case "PropertyReport":
                    _businessService = new PropertyReportService();
                    break;
                case "MapPOAndVendor":
                    _businessService = new MapPOAndVendorService();
                    break;
                case "ExportUnsettled":
                    _businessService = new ExportUnsettledService();
                    break;
                case "FormatReceipts":
                    _businessService = new FormatReceiptsService();
                    break;
                case "LaundryService":
                    _businessService = new LaundrySService();
                    break;
                case "ApprovedPettyCash":
                    _businessService = new ApprovedPettyCashService();
                    break;
                case "PettyCashHdr":
                    _businessService = new PettyCashHdrService();
                    break;
                case "VendorSettlement":
                    _businessService = new VendorSettlementService();
                    break;
                case "SearchInvoiceReport":
                    _businessService = new SearchInvoiceReportService();
                    break;
                case "InternalExpenseReport":
                    _businessService = new InternalExpenseReportService();
                    break;
                case "VendorAdvancePayment":
                    _businessService = new VendorAdvancePaymentService();
                    break;
                case "TaxMapping":
                    _businessService = new TaxMappingService();
                    break;
                case "ExternalExpenseReport":
                    _businessService = new ExternalExpenseReportService();
                    break;
                case "PendingCkinReport":
                    _businessService = new PendingCkinReportService();
                    break;
                case "CheckoutAndIntermediate":
                    _businessService = new CheckoutAndIntermediateService();
                    break;
                case "TodaysCheckinCheckout":
                    _businessService = new TodaysCheckinCheckoutService();
                    break;
                case "IntermediateCheckoutService":
                    _businessService = new IntermediateCheckoutServiceHdrService();
                    break;
                case "ExterIntermediateChkoutService":
                    _businessService = new ExternalIntermediateCheckOutService();
                    break;
                case "CheckInForecastReport":
                    _businessService = new ExternalIntermediateCheckOutService();
                    break;
            }
            return _businessService;
        }
    }
}
