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
                case "SSPCodeGeneration":
                    _businessService = new SSPCodeGenerationService();
                    break;
                case "PettyCash":
                    _businessService = new PettyCashService();
                    break;
                case "ImportGuest":
                    _businessService = new ImportGuestService();
                    break;
            }
            return _businessService;
        }
    }
}
