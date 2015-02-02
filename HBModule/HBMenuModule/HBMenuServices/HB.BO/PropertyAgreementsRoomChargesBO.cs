using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PropertyAgreementsRoomChargesBO
    {
        public DataSet Save(string Hdrval, User user, int AgreementId)
        {
            return new PropertyAgreementsRoomChargesDAO().Save(Hdrval, user, AgreementId);
        }
    }
}
