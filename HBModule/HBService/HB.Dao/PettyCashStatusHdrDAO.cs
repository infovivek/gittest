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
    public class PettyCashStatusHdrDAO
    {
        string UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            PettyCashStatusHdr PettyStHdr = new PettyCashStatusHdr();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[2]);

            PettyStHdr.PropertyId = Convert.ToInt32(doc.SelectSingleNode("//Property").Attributes["PropertyId"].Value);
            PettyStHdr.UserId = Convert.ToInt32(doc.SelectSingleNode("//Property").Attributes["UserId"].Value);
            PettyStHdr.Balance = Convert.ToDecimal(doc.SelectSingleNode("//Property").Attributes["Balance"].Value);
            PettyStHdr.Id = Convert.ToInt32(doc.SelectSingleNode("//Property").Attributes["Id"].Value);
            command = new SqlCommand();
            if (PettyStHdr.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashStatusHdr_Update" + ", ProcName:'" + StoredProcedures.PettyCashStatusHdr_Update;

                    command.CommandText = StoredProcedures.PettyCashStatusHdr_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PettyStHdr.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashStatusHdr_Insert" + ", ProcName:'" + StoredProcedures.PettyCashStatusHdr_Insert;

                    command.CommandText = StoredProcedures.PettyCashStatusHdr_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PettyStHdr.PropertyId;
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = PettyStHdr.UserId;
                command.Parameters.Add("@Balance", SqlDbType.Decimal).Value = PettyStHdr.Balance;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = PettyStHdr.UserId;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashStatusDAO Select" + ", ProcName:'" + StoredProcedures.PettyCashStatus_Select;

            PettyCashStatusEntity PettySt = new PettyCashStatusEntity();
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            //command.CommandText = StoredProcedures.PettyCashStatus_Select;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[3].ToString();
            //command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[4].ToString();
            //command.Parameters.Add("@PropertyId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[6].ToString());//Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet HelpResult(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashStatusDAO Help" + ", ProcName:'" + StoredProcedures.PettyCashStatus_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PettyCashStatus_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@ExpenseId", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
