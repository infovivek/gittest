using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ReassignClientDtl
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public int City { get; set; }
        public int CreatedDate { get; set; }
        public int SelectId { get; set; }
        public bool check { get; set; }
        public string RoleName { get; set; }
    }
}
