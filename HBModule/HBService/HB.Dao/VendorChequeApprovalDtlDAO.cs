using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using HB.Entity;
using System.Xml;
using System.Collections;

namespace HB.Dao
{
    public class VendorChequeApprovalDtlDAO
    {
        String UserData;
        public DataSet Save(string VendorChequeApprovalHdr, User Usr, int VendorChequeApprovalHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            VendorChequeApprovalDtl VCRD = new VendorChequeApprovalDtl();
            document.LoadXml(VendorChequeApprovalHdr);
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {
                VCRD.Process = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["Process"].Value);
                if (VCRD.Process == true)
                {
                    VCRD.RequestedOn = document.SelectNodes("//ServiceXml")[i].Attributes["RequestedOn"].Value;
                    VCRD.Requestedby = document.SelectNodes("//ServiceXml")[i].Attributes["Requestedby"].Value;
                    VCRD.RequestedAmount = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["RequestedAmount"].Value);
                    VCRD.Status = document.SelectNodes("//ServiceXml")[i].Attributes["Status"].Value;
                    VCRD.Processedon = document.SelectNodes("//ServiceXml")[i].Attributes["Processedon"].Value;
                    VCRD.Processedby = document.SelectNodes("//ServiceXml")[i].Attributes["Processedby"].Value;
                    VCRD.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                    VCRD.RequestedUserId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["RequestedUserId"].Value);
                    VCRD.PropertyId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["PropertyId"].Value);
                    command = new SqlCommand();
                    if (VCRD.Id != 0)
                    {
                        UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                            "', SctId:" + Usr.SctId + ", Service:VendorChequeApprovalDtlDAO Update" + ", ProcName:'" + StoredProcedures.VendorChequeApprovalDtl_Update;

                        command.CommandText = StoredProcedures.VendorChequeApprovalDtl_Update;
                        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = VCRD.Id;
                    }
                    else
                    {
                        UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                            "', SctId:" + Usr.SctId + ", Service:VendorChequeApprovalDtlDAO Insert" + ", ProcName:'" + StoredProcedures.VendorChequeApprovalDtl_Insert;

                        command.CommandText = StoredProcedures.VendorChequeApprovalDtl_Insert;
                    }


                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@VendorChequeApprovalHdrId", SqlDbType.Int).Value = VendorChequeApprovalHdrId;
                    command.Parameters.Add("@RequestedOn", SqlDbType.NVarChar).Value = VCRD.RequestedOn;
                    command.Parameters.Add("@Requestedby", SqlDbType.NVarChar).Value = VCRD.Requestedby;
                    command.Parameters.Add("@RequestedAmount", SqlDbType.NVarChar).Value = VCRD.RequestedAmount;
                    command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = VCRD.Status;
                    command.Parameters.Add("@Processedon", SqlDbType.NVarChar).Value = VCRD.Processedon;
                    command.Parameters.Add("@Processedby", SqlDbType.NVarChar).Value = VCRD.Processedby;
                    command.Parameters.Add("@Process", SqlDbType.Int).Value = 1;
                    command.Parameters.Add("@RequestedUserId", SqlDbType.Int).Value = VCRD.RequestedUserId;
                    command.Parameters.Add("@UserId", SqlDbType.Int).Value = Usr.Id;
                    command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = VCRD.PropertyId;
                    command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = Usr.Id;
                    ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }

            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }
            return ds;
        }
    }
}
