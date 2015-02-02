using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.Dao;
using HB.BusinessService;

namespace HB.BusinessService.BusinessService
{
    public class BookingDtlsService:IBusinessService
    {
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
            return new BookingDtlsDAO().Help(data, user);
        }
    }
}
