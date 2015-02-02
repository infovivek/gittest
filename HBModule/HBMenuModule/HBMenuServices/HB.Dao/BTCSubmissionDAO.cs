using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;
namespace HB.Dao
{
   public class BTCSubmissionDAO
    {
        String UserData;
        public DataSet Save(string[] Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            DataTable dT = new DataTable("Table");
            DataTable ErrdT = new DataTable("DBERRORTBL");
            ErrdT.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            BTCSubmission BTCS = new BTCSubmission();
            XmlDocument document = new XmlDocument();

            dTable.Columns.Add("Exception");
            dT.Columns.Add("Id");
            document.LoadXml(Hdrval[1]);     


            BTCS.ClientId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["ClientId"].Value);
            BTCS.Acknowledged = document.SelectSingleNode("HdrXml").Attributes["Acknowledged"].Value;
            BTCS.Comments = document.SelectSingleNode("HdrXml").Attributes["Comments"].Value;
            BTCS.Filename = document.SelectSingleNode("HdrXml").Attributes["Filename"].Value;
            BTCS.Physical = document.SelectSingleNode("HdrXml").Attributes["Physical"].Value;
            BTCS.Expected = document.SelectSingleNode("HdrXml").Attributes["Expected"].Value;
            BTCS.SubmittedOn = document.SelectSingleNode("HdrXml").Attributes["SubmittedOn"].Value;
            BTCS.CollectionStatus = document.SelectSingleNode("HdrXml").Attributes["CollectionStatus"].Value;
            BTCS.Id = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);

            document = new XmlDocument();
            document.LoadXml(Hdrval[2]);
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {

                BTCS.ClientId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ClientId"].Value);
                BTCS.DepositDetilsId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["DepositDetilsId"].Value);
                BTCS.ChkOutHdrId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["ChkOutHdrId"].Value);
                BTCS.InvoiceNo = document.SelectNodes("//GridXml")[i].Attributes["InvoiceNo"].Value;
                BTCS.InvoiceType = document.SelectNodes("//GridXml")[i].Attributes["InvoiceType"].Value;
                BTCS.InvoiceDate = document.SelectNodes("//GridXml")[i].Attributes["InvoiceDate"].Value;
                BTCS.CollectionStatus = document.SelectNodes("//GridXml")[i].Attributes["CollectionStatus"].Value;
                BTCS.DetailsId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);

                command = new SqlCommand();
                if (BTCS.DetailsId != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:BTC Submission Update" + ", ProcName:'" + StoredProcedures.BTCSubmission_Update;

                    command.CommandText = StoredProcedures.BTCSubmission_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BTCS.DetailsId;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:BTC Submission Insert" + ", ProcName:'" + StoredProcedures.BTCSubmission_Save;

                    command.CommandText = StoredProcedures.BTCSubmission_Save;
                }

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@DepositDetilsId", SqlDbType.BigInt).Value = BTCS.DepositDetilsId;
                command.Parameters.Add("@ChkOutHdrId", SqlDbType.BigInt).Value = BTCS.ChkOutHdrId;
                command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = BTCS.InvoiceNo;
                command.Parameters.Add("@InvoiceType", SqlDbType.NVarChar).Value = BTCS.InvoiceType;
                command.Parameters.Add("@InvoiceDate", SqlDbType.NVarChar).Value = BTCS.InvoiceDate;
                command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = BTCS.ClientId;
                command.Parameters.Add("@Acknowledged", SqlDbType.NVarChar).Value = BTCS.Acknowledged;
                command.Parameters.Add("@Comments", SqlDbType.NVarChar).Value = BTCS.Comments;
                command.Parameters.Add("@Filename", SqlDbType.NVarChar).Value = BTCS.Filename;
                command.Parameters.Add("@Physical", SqlDbType.NVarChar).Value = BTCS.Physical;
                command.Parameters.Add("@Expected", SqlDbType.NVarChar).Value = BTCS.Expected;
                command.Parameters.Add("@SubmittedOn", SqlDbType.NVarChar).Value = BTCS.SubmittedOn;
                command.Parameters.Add("@CollectionStatus", SqlDbType.NVarChar).Value = BTCS.CollectionStatus;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;

                DataSet ds1 = new WrbErpConnection().ExecuteDataSet(command, UserData);
                if (ds1.Tables[0].Rows.Count > 0)
                {
                    dT.Rows.Add(ds1.Tables[0].Rows[0][0].ToString());
                }

            }
                ds.Tables.Add(dT);
                ds.Tables.Add(ErrdT);
                return ds;
        }
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:BTCSubmissionDAO Help" + ", ProcName:'" + StoredProcedures.ApartmentBooking_Help;

            SqlCommand command = new SqlCommand();
            
            DataSet ds = new DataSet();
            if (data[1].ToString() == "IMAGEUPLOAD")
            {
                XmlDocument document = new XmlDocument();
                document = new XmlDocument();
                document.LoadXml(data[2]);
                int n;
                n = (document).SelectNodes("//BTCIDXml").Count;
                for (int i = 0; i < n; i++)
                {
                    command = new SqlCommand();
                    command.CommandText = StoredProcedures.BTCSubmission_Help;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
                    command.Parameters.Add("@Param1", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectNodes("//BTCIDXml")[i].Attributes["Id"].Value);
                    command.Parameters.Add("@Param2", SqlDbType.BigInt).Value = 0;
                    command.Parameters.Add("@Param3", SqlDbType.NVarChar).Value = data[3].ToString();
                    command.Parameters.Add("@Param4", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@Param5", SqlDbType.NVarChar).Value = "";
                    command.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = user.Id;
                    ds=new WrbErpConnection().ExecuteDataSet(command, UserData);
                }
            }
            else
            {
                command = new SqlCommand();
                command.CommandText = StoredProcedures.BTCSubmission_Help;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
                command.Parameters.Add("@Param1", SqlDbType.BigInt).Value = data[2].ToString();
                command.Parameters.Add("@Param2", SqlDbType.BigInt).Value = data[3].ToString();
                command.Parameters.Add("@Param3", SqlDbType.NVarChar).Value = data[4].ToString();
                command.Parameters.Add("@Param4", SqlDbType.NVarChar).Value = data[5].ToString();
                command.Parameters.Add("@Param5", SqlDbType.NVarChar).Value = data[6].ToString();
                command.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = user.Id;
                ds= new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }
        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service: BTC Submission Select" + ", ProcName:'" + StoredProcedures.BTCSubmission_Search;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.BTCSubmission_Search;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Param2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Param3", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
