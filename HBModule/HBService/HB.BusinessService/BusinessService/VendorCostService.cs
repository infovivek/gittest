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
    public class VendorCostService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                // string Hdrval;
                // Hdrval = data[1].ToString();
                ds = new VendorCostBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                else
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "Vendor Already Exists.")
                    {
                        dTable.Rows.Add(ds.Tables[0].Rows[0][0].ToString());
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
            throw new NotImplementedException();
        }

        public DataSet Search(string[] Hdrval, User user)
        {
            throw new NotImplementedException();
        }

        public DataSet HelpResult(string[] Hdrval, User user)
        {
            return new VendorCostBO().HelpResult(Hdrval, user);
        }
    }
}
