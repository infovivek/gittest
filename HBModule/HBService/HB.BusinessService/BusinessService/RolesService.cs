using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.BO;
using System.Configuration;
using System.Xml;
using HB.Dao;

namespace HB.BusinessService.BusinessService
{
    public class RolesService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval = (data[1].ToString());
                DataSet ds1 = new RolesBo().Save(Hdrval, user);
                if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
               }
                if (ds1.Tables[0].Rows[0][0].ToString() == "Role Name Already Exists")
               {
                   dTable.Rows.Add("Role Name Already Exists.");
               }
                else
                {
                        Int32 RolesId = Convert.ToInt32(ds1.Tables[0].Rows[0][0].ToString());
                        string Dtlval = data[2].ToString();
                        DataSet ds2 = new RolesDetailsBo().Save(RolesId, Dtlval, user);
                 }
               }
           
            catch (Exception Ex)
            {
                CreateLogFilesService Err = new CreateLogFilesService();
                Err.ErrorLog(Ex.Message);
                dTable.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
            }
            finally
            {
                ds.Tables.Add(dTable);
                dTable.Dispose();
                dTable = null;
            }
            return ds;
        }

        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new RolesBo().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new RolesBo().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new RolesBo().Help(data, user);
        }
    }
}
