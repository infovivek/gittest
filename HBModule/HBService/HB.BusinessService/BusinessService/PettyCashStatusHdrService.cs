﻿using System;
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
    public class PettyCashStatusHdrService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            try
            {
                string Hdrval = (data[2].ToString());
                ds = new PettyCashStatusHdrBO().Save(data, user);
                if (ds.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(ds.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (ds.Tables[0].Rows[0][0].ToString() == "PC Expense Report Can be submit after the Previous Expense Report Approval.")
                {
                    dTable.Rows.Add("PC Expense Report Can be submit after the Previous Expense Report Approval.");
                }
                 else
                {
                    Int32  PettyCashStatusHdrId = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());
                    string PettyCashStatusRowId = ds.Tables[0].Rows[0][1].ToString();
                    string PettyCashStatusHdr = data[1].ToString();
                    DataSet ds1 = new PettyCashStatusBO().Save(PettyCashStatusHdr, user, PettyCashStatusHdrId);
                    if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
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
            return new PettyCashStatusHdrBO().HelpResult(data, user);
        }
    
    }
}
