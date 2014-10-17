﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using HB.BO;
using HB.BusinessService;

namespace HB.BusinessService.BusinessService
{
    public class MasterClientManagementService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                DataSet ds_Hdr = new MasterClientManagementBo().Save(data, user);
                if (ds_Hdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds_Hdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    //Int32 HdrId = Convert.ToInt32(ds_Hdr.Tables[0].Rows[0][0]);
                    //string RowId = ds_Hdr.Tables[0].Rows[0][1].ToString();
                    //DataSet ds_Dtls1 = new ClientMgntAddNewClientBO().Save(RowId, HdrId, data[3], user);
                    //if (ds_Dtls1.Tables["DBERRORTBL"].Rows.Count > 0)
                    //{
                    //    dTable.Rows.Add(ds_Dtls1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    //}
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
                ds.Tables.Add(dTable); dTable.Dispose(); dTable = null;
            }
            return ds;
        }
   
        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new MasterClientManagementBo().Delete(data, user);
            ds.Tables.Add(dTable);
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            return new MasterClientManagementBo().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            return new MasterClientManagementBo().Help(data, user);
        }
    }

}