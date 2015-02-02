using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class ClientMgntClientguest
    { 
       public int  CltmgntId { get; set; }
       public string  CompanyName  { get; set; }
       public string  EmpCode	{ get; set; }
       public string  FirstName	{ get; set; }
       public string  LastName	{ get; set; }
       public string  Grade		{ get; set; }
       public string  MobileNo	{ get; set; }
       public string  EmailId	{ get; set; }
       public decimal RangeMin	{ get; set; }
       public decimal RangeMax	{ get; set; }
       public string CreatedBy { get; set; }
       public int Id { get; set; }
       public string Designation { get; set; }
    }
}
