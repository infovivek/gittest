﻿using System;
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
    public class PettyCashApprovalDtlDAO
    {
        String UserData;
        public DataSet Save(string PettyCashApprovalHdr, User Usr, int PettyCashApprovalHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            PettyCashApprovalDtl PCRD = new PettyCashApprovalDtl();
            document.LoadXml(PettyCashApprovalHdr);
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {
                PCRD.Process = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["Process"].Value);
                if (PCRD.Process == true)
                {
                    PCRD.RequestedOn = document.SelectNodes("//ServiceXml")[i].Attributes["RequestedOn"].Value;
                    PCRD.Requestedby = document.SelectNodes("//ServiceXml")[i].Attributes["Requestedby"].Value;
                    PCRD.PCAccount = document.SelectNodes("//ServiceXml")[i].Attributes["PCAccount"].Value;
                    PCRD.RequestedAmount = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["RequestedAmount"].Value);
                    PCRD.RequestedStatus = document.SelectNodes("//ServiceXml")[i].Attributes["RequestedStatus"].Value;
                    PCRD.ProcessedStatus = document.SelectNodes("//ServiceXml")[i].Attributes["ProcessedStatus"].Value;
                    //PCRD.Status = document.SelectNodes("//ServiceXml")[i].Attributes["Status"].Value;
                    PCRD.Processedon = document.SelectNodes("//ServiceXml")[i].Attributes["Processedon"].Value;
                    PCRD.Comments = document.SelectNodes("//ServiceXml")[i].Attributes["Comments"].Value;
                    PCRD.RequestedUserId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["RequestedUserId"].Value);
                    PCRD.PropertyId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["PropertyId"].Value);
                    PCRD.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                    command = new SqlCommand();
                    if (PCRD.Id != 0)
                    {
                        UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                            "', SctId:" + Usr.SctId + ", Service:PettyCashApprovalDtlDAO Update" + ", ProcName:'" + StoredProcedures.PettyCashApprovalDtl_Update; 

                        command.CommandText = StoredProcedures.PettyCashApprovalDtl_Update;
                        command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PCRD.Id;
                    }
                    else
                    {
                        UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                            "', SctId:" + Usr.SctId + ", Service:PettyCashApprovalDtlDAO Insert" + ", ProcName:'" + StoredProcedures.PettyCashApprovalDtl_Insert; 

                        command.CommandText = StoredProcedures.PettyCashApprovalDtl_Insert;
                    }


                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@PettyCashApprovalHdrId", SqlDbType.Int).Value = PettyCashApprovalHdrId;
                    command.Parameters.Add("@RequestedOn", SqlDbType.NVarChar).Value = PCRD.RequestedOn;
                    command.Parameters.Add("@Requestedby", SqlDbType.NVarChar).Value = PCRD.Requestedby;
                    command.Parameters.Add("@PCAccount", SqlDbType.NVarChar).Value = PCRD.PCAccount;
                    command.Parameters.Add("@RequestedAmount", SqlDbType.NVarChar).Value = PCRD.RequestedAmount;
                    command.Parameters.Add("@RequestedStatus", SqlDbType.NVarChar).Value = PCRD.RequestedStatus;
                    command.Parameters.Add("@ProcessedStatus", SqlDbType.NVarChar).Value = PCRD.ProcessedStatus;
                   // command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = PCRD.Status;
                    command.Parameters.Add("@LastProcessedon", SqlDbType.NVarChar).Value = PCRD.Processedon;
                    command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = PCRD.Comments;
                    command.Parameters.Add("@RequestedUserId", SqlDbType.Int).Value = PCRD.RequestedUserId;
                    command.Parameters.Add("@Process", SqlDbType.Int).Value = 1;
                    command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = PCRD.PropertyId;
                    command.Parameters.Add("@UserId", SqlDbType.Int).Value = Usr.Id;
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
       

