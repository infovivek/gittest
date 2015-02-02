using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
   public class ApartmentBO
   {
       public DataSet Save(string Hdrval, User user)
       {
           return new ApartmentDAO().Save(Hdrval, user);
       }
       public DataSet Search(string[] data, User user)
       {
           return new ApartmentDAO().Search(data, user);
       }
        public DataSet Delete(string[] data, User user)
       {
           return new ApartmentDAO().Delete(data, user); 
       }
       public DataSet Help(string[] data, User user)
       {
            return new ApartmentDAO().Help(data,user); 
       }

   }
}
