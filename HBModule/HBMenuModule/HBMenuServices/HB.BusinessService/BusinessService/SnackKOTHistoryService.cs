using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using HB.BO;
using HB.BusinessService;

namespace HB.BusinessService.BusinessService
{
    public class SnackKOTHistoryService : IBusinessService
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
            return new SnackKOTHistoryBO().HelpResult(data, user);
        }
    }
}
