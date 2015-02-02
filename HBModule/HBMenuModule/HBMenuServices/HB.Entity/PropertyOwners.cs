using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
  public  class PropertyOwners
    {
    public string  PropertyId  { get; set; }
    public string  FirstName { get; set; }
    public string  Lastname { get; set; }
    public string  LedgerName { get; set; }
    public string  EmailID { get; set; }
    public string  PhoneNumber { get; set; }
    public string  Alternatephone { get; set; }
    public int  TDSPer   { get; set; }
    public string  Address { get; set; }
    public string  City { get; set; }
    public string  LocalityArea { get; set; }
    public string  State { get; set; }
    public string  Postal { get; set; }
    public string  PaymentMode { get; set; }
    public string  PayeeName { get; set; }
    public string  AccountNumber { get; set; }
    public string  AccountType { get; set; }
    public string  Bank { get; set; }
    public string  BranchAddress { get; set; }
    public string  IFSC { get; set; }
    public string  SWIFTCode { get; set; }
    public string  PANNO { get; set; }
    public string  TIN { get; set; }
    public string  ST { get; set; }
    public string  VAT { get; set; }
    public decimal RackRates { get; set; }

    public int LocalityId { get; set; } 
    public int CityId { get; set; } 
    public int StateId { get; set; }
    public int CreatedBy  { get; set; } 
    public int Id { get; set; }

    public string Title { get; set; }
    }
}
