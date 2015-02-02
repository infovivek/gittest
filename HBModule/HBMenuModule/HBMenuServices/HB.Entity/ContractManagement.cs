using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractManagement
    {
     public string CreatedBy { get; set; }
     public string ContractType  { get; set; }
     public string ContractName  { get; set; }
     public string Property  { get; set; }
     public string BookingLevel { get; set; }
     public string StartDate  { get; set; }
     public string EndDate { get; set; }
     public string ExtenstionDate { get; set; }
     public string ContractPriceMode { get; set; }
     public string RateInterval { get; set; }
     public string SalesExecutive  { get; set; }
     public string AgreementDate  { get; set; }
     public string ClientName { get; set; } 

     public int  PropertyId { get; set; }
     public int ClientId { get; set; }
     public int SalesExecutiveId { get; set; }
     public string PrintingModel  { get; set; }
     public string Types { get; set; }
     public string Status  { get; set; }
     public string TransubName { get; set; }
     public int TransubId { get; set; }
     public int Id { get; set; } 
    }
}
