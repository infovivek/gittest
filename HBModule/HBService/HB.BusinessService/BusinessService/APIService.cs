using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using HB.Dao;
using HB.BO;
using HB.BusinessService;
using System.Data;

namespace HB.BusinessService.BusinessService
{
    public class APIService:IBusinessService
    {
        DataSet ds = new DataSet();
        public DataSet Save(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Delete(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, User user)
        {
            ds = new DataSet();
            if(data[1].ToString() == "GetAPIdata")
            {
                ds = new APIDynamicDAO().FnDynamicData(data, user);
            }
            if (data[1].ToString() == "MMTdata")
            {
                ds = new APICreateReservationDAO().FnCreateReservation(data, user);
            }
            if (data[1].ToString() == "AvailabilityExistingData")
            {
                ds = new APIAvailabilityExistingDataDAO().FnAvailabilityExistingData(data, user);
            }
            if (data[1].ToString() == "StaticData")
            {
                ds = new APIStaticDataDAO().FnstaticData(user);
            }
            return ds;
        }
    }
}
