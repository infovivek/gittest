using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
   public class ContractNonDedicatedBO
    {
            public DataSet Save(string data, User user)
            {
                return new ContractNonDedicatedDAO().Save(data, user);
            }
            public DataSet Search(string[] data, User user)
            {
                return new ContractNonDedicatedDAO().Search(data, user);
            }
            public DataSet Delete(string[] data, User user)
            {
                return new ContractNonDedicatedDAO().Delete(data, user);
            }
            public DataSet Help(string[] data, User user)
            {
                return new ContractNonDedicatedDAO().Help(data, user);
            }
        }
    } 
