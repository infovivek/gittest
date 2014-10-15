 using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using HB.BO;
using System.Configuration;
using HB.Dao;

namespace HB.BusinessService.BusinessService
{
    public class ReassignClientService : IBusinessService
    {
        
        public DataSet Save(string[] data, User user = default(User))
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval;
                Hdrval = data[1].ToString();
                DataSet Hdr = new ReassignClientBO().Save(data, user);
                if (Hdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(Hdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    Int32 ReassignClientId = Convert.ToInt32(Hdr.Tables[0].Rows[0][0].ToString());
                    string ReassignClientRowId = Hdr.Tables[0].Rows[0][1].ToString();
                    string ReassignClientDtls = data[2].ToString();
                    DataSet ds1 = new ReassignClientDtlBo().Save(data, user, ReassignClientId);
                    if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                }
            }
            catch (Exception Ex)
            {
                CreateLogFiles Err = new CreateLogFiles();
                Err.ErrorLog(Ex.Message + "Service");
                dTable.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
            }
            finally
            {
                ds.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }
            return ds;
        }

        public DataSet Delete(string[] data, User user = default(User))
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            DataSet ds1 = new ReassignClientBO().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user = default(User))
        {
            return new ReassignClientBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new ReassignClientBO().Help(data, user);
        }
    }
 }

