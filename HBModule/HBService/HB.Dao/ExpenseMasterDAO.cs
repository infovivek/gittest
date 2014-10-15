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
    public class ExpenseMasterDAO
    {
        String UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            ExpenseMasterEntity Exp = new ExpenseMasterEntity();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            doc.LoadXml(data[1].ToString());
            SqlCommand command = new SqlCommand();

            Exp.ExpenseGroupId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["ExpenseGroupId"].Value);
            Exp.Id = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
            Exp.ExpenseHead = doc.SelectSingleNode("//HdrXml").Attributes["ExpenseHead"].Value;
            Exp.Status = doc.SelectSingleNode("//HdrXml").Attributes["Status"].Value;
            if (Exp.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ExpenseMasterDAO Update" + ", ProcName:'" + StoredProcedures.ExpenseMaster_Update; 

                command.CommandText = StoredProcedures.ExpenseMaster_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = Exp.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:ExpenseMasterDAO Insert" + ", ProcName:'" + StoredProcedures.ExpenseMaster_Insert; 

                command.CommandText = StoredProcedures.ExpenseMaster_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@ExpenseHead", SqlDbType.NVarChar).Value = Exp.ExpenseHead;
            command.Parameters.Add("@ExpenseGroupId", SqlDbType.BigInt).Value = Exp.ExpenseGroupId;
            command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = Exp.Status;
            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;

        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:ExpenseMasterDAO Help" + ", ProcName:'" + StoredProcedures.ExpenseMaster_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ExpenseMaster_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Search(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
             "', SctId:" + user.SctId + ", Service:ExpenseMasterDAO Select" + ", ProcName:'" + StoredProcedures.ExpenseMaster_Select; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ExpenseMaster_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
