using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class ContractManagementTariffAppartment
    {
      public string Place { get; set; }
      public string Property { get; set; }
      public string Attachedon { get; set; }
      public string Detachedon { get; set; }
      public bool Detach { get; set; }
      public int CreatedBy { get; set; }
      public int Id { get; set; }

      public int BlockId { get; set; } 
      public int RoomId { get; set; }
      public int ApartmentId { get; set; }
      public string AttachedBy { get; set; }
      public int PropertyId { get; set; }
      public Decimal Tariff { get; set; }
    }
}
