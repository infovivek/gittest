﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{


    public class RolesBo
   {
       public DataSet Save(string Hdrval, User user)
       {
           return new RolesDAO().Save(Hdrval, user);
       }
       public DataSet Search(string[] data, User user)
       {
           return new RolesDAO().Search(data, user);
       }
        public DataSet Delete(string[] data, User user)
       {
           return new RolesDAO().Delete(data, user); 
       }
       public DataSet Help(string[] data, User user)
       {
            return new RolesDAO().Help(data,user); 
       }
    }
}
