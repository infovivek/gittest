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
using System.Data.Sql;
using System.Net.Mail;

namespace HB.Dao
{
   public class VendorDao
    {
       string UserData;
        public DataSet Save(string[] Hdrval, User user)
        {
     
            Vendor ven = new Vendor();
            XmlDocument document = new XmlDocument();
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");

            //User Insert(detailed)
            document.LoadXml(Hdrval[1].ToString());
            SqlCommand command = new SqlCommand();
            ven.Id = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
            if (ven.Id != 0)
            {
                UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName +",ScreenName:'" + user.ScreenName + 
                    "',SctId:" + user.SctId + ",Service:  VendorDao Update" +",ProcName:'" + StoredProcedures.Vendor_Update;

                command.CommandText = StoredProcedures.Vendor_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = ven.Id;
            }
            else
            {
                UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                 "',SctId:" + user.SctId + ",Service:  VendorDao Insert" + ",ProcName:'" + StoredProcedures.Vendor_Insert;

                command.CommandText = StoredProcedures.Vendor_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
    command.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["FirstName"].Value;
    command.Parameters.Add("@MobileNumber", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Mobile"].Value;
    command.Parameters.Add("@Category", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Category"].Value;
    command.Parameters.Add("@VendorName", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["VendorName"].Value;
    command.Parameters.Add("@Designation", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Designation"].Value;
     
    command.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["LastName"].Value;
    command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Email"].Value;
    command.Parameters.Add("@Address", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["address"].Value;
    command.Parameters.Add("@NatureOfService", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["NatureOfService"].Value;
    command.Parameters.Add("@City", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["City"].Value;
    command.Parameters.Add("@Office", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Office"].Value;
    command.Parameters.Add("@State", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["State"].Value;

    command.Parameters.Add("@Website", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Website"].Value;
    command.Parameters.Add("@Pancard", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Pancard"].Value;
    command.Parameters.Add("@CategoryId", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["CategoryId"].Value);
    command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["StateId"].Value);
    command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["CityId"].Value);

    command.Parameters.Add("@saletaxnum", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["saletaxnum"].Value;
    command.Parameters.Add("@saletaxdate", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["saletaxdate"].Value;
    command.Parameters.Add("@ServtaxNum", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["ServtaxNum"].Value;
    command.Parameters.Add("@servicetaxdate", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["servicetaxdate"].Value;
    command.Parameters.Add("@Cheque", SqlDbType.Bit).Value = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["Cheque"].Value);
    command.Parameters.Add("@OnlineTransfer", SqlDbType.Bit).Value = Convert.ToBoolean(document.SelectSingleNode("//HdrXml").Attributes["OnlineTransfer"].Value);
    command.Parameters.Add("@Bank", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["Bank"].Value;
    command.Parameters.Add("@PayeeName", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["PayeeName"].Value;
    command.Parameters.Add("@IFSC", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["IFSC"].Value;

    command.Parameters.Add("@AccountNo", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["AccountNo"].Value;
    command.Parameters.Add("@AccountType", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["AccountType"].Value;
    command.Parameters.Add("@PaymentCircle", SqlDbType.NVarChar).Value = document.SelectSingleNode("//HdrXml").Attributes["PaymentCircle"].Value;
    command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
    command.Parameters.Add("@BankId", SqlDbType.BigInt).Value = document.SelectSingleNode("//HdrXml").Attributes["BankId"].Value;

     ds = new WrbErpConnection().ExecuteDataSet(command, UserData);  
     return ds;
        }
        public DataSet Delete(string[] Hdrval, User user)
        {
            SqlCommand command = new SqlCommand();
            command = new SqlCommand();
            command.CommandText = StoredProcedures.Vendor_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(Hdrval[1].ToString());
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value =  Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }

        public DataSet Search(string[] Hdrval, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
               "',SctId:" + user.SctId + ",Service:  Vendordao  Search" + ",ProcName:'" + StoredProcedures.Vendor_Select;
            SqlCommand command = new SqlCommand();
            command = new SqlCommand();
            command.CommandText = StoredProcedures.Vendor_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Hdrval[1].ToString();
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet HelpResult(string[] Hdrval, User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
              "',SctId:" + user.SctId + ",Service:  Vendordao  Help" + ",ProcName:'" + StoredProcedures.Vendor_Help;
            SqlCommand command = new SqlCommand();
            command = new SqlCommand();
            command.CommandText = StoredProcedures.Vendor_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@PAction", SqlDbType.NVarChar).Value = Hdrval[1].ToString();
            command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = Hdrval[2].ToString();
            command.Parameters.Add("@Param2", SqlDbType.NVarChar).Value = Hdrval[3].ToString();
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Hdrval[4].ToString();
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Hdrval[5].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData );
        }
    }
}
