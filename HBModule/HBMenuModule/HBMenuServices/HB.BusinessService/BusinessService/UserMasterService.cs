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
    public class UserMasterService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval;
                Hdrval = data[1].ToString();
                ds = new UserMasterBo().Save(data, user);

                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    if (ds.Tables[0].Rows[0][0].ToString() != "UserName or EmailId Already Exist")
                    {
                      //  if (ds.Tables[0].Rows[0][0].ToString() != "Email Address Already Exist")
                      //  {
                            Int32 UserId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                            string UserRowId = ds.Tables[0].Rows[0][1].ToString();
                            string Dtlval = data[2].ToString();
                            ds = new UserRolesBO().Save(UserId, Dtlval, user);
                        }
                        else
                        {
                              dTable.Rows.Add("User Name or EmailId  Already Exists.");
                        }
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

        public DataSet Delete(string[] Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new UserMasterBo().Delete(Hdrval, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] Hdrval, User user)
        {
            return new UserMasterBo().Search(Hdrval, user);
        }

        public DataSet HelpResult(string[] Hdrval, User user)
        {
            return new UserMasterBo().HelpResult(Hdrval, user);
        }
    }
}