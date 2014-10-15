using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class PropertyAgreementsRoomCharges
    {
        public int AgreementId { get; set; }
        public decimal RackSingle { get; set; }
        public decimal RackDouble { get; set; }
        public decimal RackTriple { get; set; }
        public string Description { get; set; }
        public decimal Tax { get; set; }
        public string Facility { get; set; }
        public Boolean Inclusive { get; set; }
        public decimal Amount { get; set; }
        public string RoomType { get; set; }
        public string CreatedBy { get; set; }
        public int Id { get; set; }
        public decimal Single { get; set; }
        public decimal Double { get; set; }
        public decimal Triple { get; set; }
        public decimal LTAgreed { get; set; }
        public decimal STAgreed { get; set; }
        public decimal LTRack { get; set; }
        public decimal STRack { get; set; }
        public decimal SC { get; set; }
        public Boolean Visible { get; set; }
    }
}
