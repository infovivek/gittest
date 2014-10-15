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
    public class ContractNonDedicatedService : IBusinessService
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
                DataSet dsHdr = new ContractNonDedicatedBO().Save(Hdrval, user);
                if (dsHdr.Tables["DBERRORTBL"].Rows.Count > 0)
                {
                    dTable.Rows.Add(dsHdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
                }
                if (dsHdr.Tables[0].Rows[0][0].ToString() == "ContractName Already Exists")
                {
                    dTable.Rows.Add("Contract Name Already Exists");
                }
                else
                {
                    //Int32 ContractId = Convert.ToInt32(dsHdr.Tables[0].Rows[0][0].ToString());
                    //string ContractTariffRowId = dsHdr.Tables[0].Rows[0][1].ToString();
                    //string ContractTariffDtls = data[2].ToString();
                    //DataSet ds1 = new ContractManagementTariffBO().Save(ContractTariffDtls, user, ContractId); 
                    //if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                    //{
                    //    dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    //}
                    //else
                    //{
                    Int32 NonDedicatedContractId = Convert.ToInt32(dsHdr.Tables[0].Rows[0][0].ToString());
                    string NonDedicatedContractRowId = dsHdr.Tables[0].Rows[0][1].ToString();
                    string NonDedicatedContractApartDtls = data[2].ToString();
                    DataSet ds1 = new ContractNonDedicatedApartmentBO().Save(NonDedicatedContractApartDtls, user, NonDedicatedContractId);
                    if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                    {
                        dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                    }
                    else
                    {
                        string NonDedicatedContractServicesDtls = data[3].ToString();
                        ds1 = new ContractNonDedicatedServiceBO().Save(NonDedicatedContractServicesDtls, user, NonDedicatedContractId);
                        if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                        {
                            dTable.Rows.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                        }
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
        public DataSet Delete(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ContractNonDedicatedBO().Delete(data, user);
            //if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
            // {
            //     dTable.Rows.Add("No Data for Deleteing This Category");
            // }
            ds.Tables.Add(dTable);
            return ds;
        }

        public DataSet Search(string[] data, User user)
        {
            return new ContractNonDedicatedBO().Search(data, user);
        }

        public DataSet HelpResult(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            DataSet ds1 = new ContractNonDedicatedBO().Help(data, user);
            return ds1;
        }
    }
}
