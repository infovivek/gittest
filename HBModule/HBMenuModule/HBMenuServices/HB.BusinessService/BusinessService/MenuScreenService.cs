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
    class MenuScreenService:IBusinessService
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Delete(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] data, Entity.User user)
        {
            return new MenuScreenBO().Help(data, user);
        }
    }
}
