using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Xml;
using System.Collections;
using HB.Entity;

namespace HB.Dao
{
    public class TransSubsPriceModelDAO
    {
        string UserData;
        SqlCommand cmd = new SqlCommand();
        public DataSet Save(string[] Hdrval, User user)
        {
            TransSubsEntity Trans = new TransSubsEntity();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            doc.LoadXml(Hdrval[1].ToString());

            int n;
            n = (doc).SelectNodes("//HdrXml").Count;
            for (int i = 0; i < n; i++)
            {
                if (doc.SelectNodes("//HdrXml")[i].Attributes["Id"].Value == "")
                {
                    Trans.Id = 0;
                }
                else
                {
                    Trans.Id = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["Id"].Value);
                }

                //Trans.Types = doc.SelectNodes("//HdrXml")[i].Attributes["Types"].Value;
                Trans.Name = doc.SelectNodes("//HdrXml")[i].Attributes["Name"].Value;
                Trans.Amount = doc.SelectNodes("//HdrXml")[i].Attributes["Amount"].Value;
                if (doc.SelectNodes("//HdrXml")[i].Attributes["AllowedBookings"].Value == "")
                {
                    Trans.AllowedBookings = 0;
                }
                else
                {
                    Trans.AllowedBookings = Convert.ToInt32(doc.SelectNodes("//HdrXml")[i].Attributes["AllowedBookings"].Value);
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["EscalationTenure"].Value == "")
                {
                    Trans.EscalationTenure = "";
                }
                else
                {
                    Trans.EscalationTenure = doc.SelectNodes("//HdrXml")[i].Attributes["EscalationTenure"].Value;
                }
                if (doc.SelectNodes("//HdrXml")[i].Attributes["EscalationPercentage"].Value == "")
                {
                    Trans.EscalationPercentage = 0;
                }
                else
                {
                    Trans.EscalationPercentage = Convert.ToDecimal(doc.SelectNodes("//HdrXml")[i].Attributes["EscalationPercentage"].Value);
                }
                
                SqlCommand cmd = new SqlCommand();
                if (Trans.Id != 0)
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  TransSubsPriceModelDAO  Update" + ",ProcName:'" + StoredProcedures.TransSubsPriceModel_Update;

                    cmd.CommandText = StoredProcedures.TransSubsPriceModel_Update;
                    cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Trans.Id;
                }
                else
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  TransSubsPriceModelDAO  save" + ",ProcName:'" + StoredProcedures.TransSubsPriceModel_Insert;

                    cmd.CommandText = StoredProcedures.TransSubsPriceModel_Insert;
                }
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Types", SqlDbType.NVarChar).Value = "Subscription";//Trans.Types;
                cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = Trans.Name;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = Trans.Amount;
                cmd.Parameters.Add("@AllowedBookings", SqlDbType.BigInt).Value = Trans.AllowedBookings;
                cmd.Parameters.Add("@EscalationTenure",SqlDbType.NVarChar).Value = Trans.EscalationTenure;
                cmd.Parameters.Add("@EscalationPercentage", SqlDbType.NVarChar).Value = Trans.EscalationPercentage;
                cmd.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(cmd, UserData);
                //return ds;
            }
            
            return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  TransSubsPriceModelDAO  Select" + ",ProcName:'" + StoredProcedures.TransSubsPriceModel_Select;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TransSubsPriceModel_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Delete(string[] data, Entity.User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  TransSubsPriceModelDAO  Delete" + ",ProcName:'" + StoredProcedures.TransSubsPriceModel_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TransSubsPriceModel_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = data[3].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  TransSubsPriceModelDAO  Help" + ",ProcName:'" + StoredProcedures.TransSubsPriceModel_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TransSubsPriceModel_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}