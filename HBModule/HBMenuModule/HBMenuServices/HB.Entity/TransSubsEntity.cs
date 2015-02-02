using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;

namespace HB.Entity
{
    public class TransSubsEntity
    {
        public string Types { get; set; }
        public string Name { get; set; }
        public string Amount { get; set; }
        public int AllowedBookings { get; set; }
        public decimal EscalationPercentage { get; set; }
        public string EscalationTenure { get; set; }
        public int Id { get; set; }
    }
}
