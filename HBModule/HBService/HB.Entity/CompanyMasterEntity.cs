using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class CompanyMasterEntity
    {
        public string LegalCompanyName { get; set; }
        public string CompanyShortName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string PanCardNo { get; set; }
        public int Id { get; set; }
        public string Logo { get; set; }
    }
}
