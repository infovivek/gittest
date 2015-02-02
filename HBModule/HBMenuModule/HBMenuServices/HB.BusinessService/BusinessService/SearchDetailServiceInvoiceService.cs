using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using HB.Dao;
using System.Data;

namespace HB.BusinessService.BusinessService
{
  public class SearchDetailServiceInvoiceService:IBusinessService
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
            return new SearchDetailServiceInvoiceDAO().Help(data, user);
        }
    }
}
