using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
   public  class PropertyUserEntity
    { 
        public string UserType  { get; set; } 
        public int UserId { get; set; }
        public string UserName { get; set; } 
        public string CreatedBy { get; set; } 
        public int Id { get; set; }
    }
}
