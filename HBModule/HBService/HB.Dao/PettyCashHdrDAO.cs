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
    public class PettyCashHdrDAO
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string[] data, User user)
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            PettyCashHdr Petty = new PettyCashHdr();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(data[1]);

            Petty.PropertyId = Convert.ToInt32(doc.SelectSingleNode("//Property").Attributes["PropertyId"].Value);
            Petty.UserId = Convert.ToInt32(doc.SelectSingleNode("//Property").Attributes["UsrId"].Value);
            Petty.Date = doc.SelectSingleNode("//Property").Attributes["Date"].Value;
            Petty.Total = Convert.ToDecimal(doc.SelectSingleNode("//Property").Attributes["Total"].Value);
            Petty.ExpenseGroupId = Convert.ToInt32(doc.SelectSingleNode("//Property").Attributes["ExpenseGroupId"].Value);
            if (doc.SelectSingleNode("//Property").Attributes["OpeningBalance"].Value == "")
            {
                Petty.OpeningBalance = 0;
            }
            else
            {
                Petty.OpeningBalance = Convert.ToDecimal(doc.SelectSingleNode("//Property").Attributes["OpeningBalance"].Value);
            }
            
            command = new SqlCommand();
            if (Petty.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashDAO Update" + ", ProcName:'" + StoredProcedures.PettyCashHdr_Update;

                    command.CommandText = StoredProcedures.PettyCashHdr_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Petty.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PettyCashDAO Insert" + ", ProcName:'" + StoredProcedures.PettyCashHdr_Insert;

                    command.CommandText = StoredProcedures.PettyCashHdr_Insert;
                }

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = Petty.Date;
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Petty.UserId;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Petty.PropertyId;
                command.Parameters.Add("@Total", SqlDbType.Decimal).Value = Petty.Total;
                command.Parameters.Add("@ExpenseGroupId", SqlDbType.BigInt).Value = Petty.ExpenseGroupId;
                command.Parameters.Add("@OpeningBalance", SqlDbType.Decimal).Value = Petty.OpeningBalance;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashDAO Select" + ", ProcName:'" + StoredProcedures.PettyCashHdr_Select;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PettyCashHdr_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:PettyCashDAO Help" + ", ProcName:'" + StoredProcedures.PettyCashHdr_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.PettyCashHdr_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
