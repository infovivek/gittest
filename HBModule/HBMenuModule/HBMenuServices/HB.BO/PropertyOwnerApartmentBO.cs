using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PropertyOwnerApartmentBO
    {
        public DataSet Save(string ApatmentId, Int32 PrptyOwnerId, string PrtyOwnerApartment, User user)
        {
            return new PropertyOwnerApartmentDAO().Save(ApatmentId, PrptyOwnerId, PrtyOwnerApartment, user);
        }
    }
}
