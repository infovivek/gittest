using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public class ClientMgntAddNewClient
    {
        public int  CltmgntId   { get; set; }
        public string  ContactType { get; set; }
        public string  Title		  { get; set; }
        public string  FirstName	  { get; set; }
        public string  LastName	  { get; set; }
        public string  Gender	  { get; set; }
        public string  Designation { get; set; }
        public string  MobileNo	 { get; set; }
        public string  Email		 { get; set; }
        public string  AlternateEmail { get; set; }
        public string  CreatedBy { get; set; }
        public int     Id { get; set; } 
    }
}
