using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ClientGradeCity
    {

        public int ClientId { get; set; }

        public int GradeId { get; set; }

        public decimal MinValue { get; set; }

        public decimal MaxValue { get; set; }

        public string Grade { get; set; }

        public int Id { get; set; }

        public int CreatedBy { get; set; }

        public bool ValueStarRatingFlag { get; set; }

        public int StarRatingId { get; set; }
       
    }
}
