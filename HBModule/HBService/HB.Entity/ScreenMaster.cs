using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
     public class ScreenMaster
    { 
        public string ScreenName { get; set; }
        public string ModuleName { get; set; }
        public int ModuleId { get; set; }
        public string SubModuleName { get; set; }
        public string SWF { get; set; }
        public int CountId { get; set; }
        public string Date { get; set; }
        public int Id { get; set; }
        public int OrderId { get; set; }
    }
}