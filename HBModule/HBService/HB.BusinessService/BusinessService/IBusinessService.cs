using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;

namespace HB.BusinessService.BusinessService
{ 
    public interface IBusinessService
    {
        DataSet Save(string[] data, User user);
        DataSet Delete(string[] data, User user );
        DataSet Search(string[] data, User user);
        DataSet HelpResult(string[] data, User user);
    }
}
