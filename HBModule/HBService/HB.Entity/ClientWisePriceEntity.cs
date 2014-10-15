using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ClientWisePriceEntity
    {
        public int Id { get; set; }
        public int PriceId { get; set; }
        public int ClientId { get; set; }
        public string Date { get; set; }
    }
}
