using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
  public  class ClientMgntCustomFields
    {
        public int CltmgntId { get; set; }
        public string FieldName	{ get; set; }
        public string FieldType	{ get; set; }
        public bool FieldValue	{ get; set; }
 
        public string CreatedBy { get; set; }
        public int Id { get; set; } 
    }
}
