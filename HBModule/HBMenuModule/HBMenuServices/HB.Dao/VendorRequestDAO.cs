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
    public class VendorRequestDAO
    {
        string UserData;
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[1].ToString());
            VendorRequest VR = new VendorRequest();

            VR.PropertyId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["PropertyId"].Value);
            VR.Property = doc.SelectSingleNode("//HdrXml").Attributes["Property"].Value;
            VR.CategoryId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["CategoryId"].Value);
            VR.Category = doc.SelectSingleNode("//HdrXml").Attributes["Category"].Value;
            VR.VendorId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["VendorId"].Value);
            VR.VendorName = doc.SelectSingleNode("//HdrXml").Attributes["VendorName"].Value;
            VR.Service = doc.SelectSingleNode("//HdrXml").Attributes["Service"].Value;
            VR.Type = doc.SelectSingleNode("//HdrXml").Attributes["Type"].Value;
            if (doc.SelectSingleNode("//HdrXml").Attributes["ApartmentId"].Value == "")
            {
                VR.ApartmentId = 0;
            }
            else
            {
                VR.ApartmentId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["ApartmentId"].Value);
            }
            if (doc.SelectSingleNode("//HdrXml").Attributes["RoomId"].Value == "")
            {
                VR.RoomId = 0;
            }
            else
            {
                VR.RoomId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["RoomId"].Value);
            }
            VR.Date = doc.SelectSingleNode("//HdrXml").Attributes["Date"].Value;
            if (doc.SelectSingleNode("//HdrXml").Attributes["Amount"].Value == "")
            {
                VR.Amount = 0;
            }
            else
            {
                 VR.Amount = Convert.ToDecimal(doc.SelectSingleNode("//HdrXml").Attributes["Amount"].Value);
            }
            if (doc.SelectSingleNode("//HdrXml").Attributes["BillNo"].Value == "")
            {
                VR.BillNo = "";
            }
            else
            {
                VR.BillNo = doc.SelectSingleNode("//HdrXml").Attributes["BillNo"].Value;
            }
            if (doc.SelectSingleNode("//HdrXml").Attributes["Duedate"].Value == "")
            {
                VR.Duedate = "";
            }
            else
            {

                VR.Duedate = doc.SelectSingleNode("//HdrXml").Attributes["Duedate"].Value;
            }
            if (doc.SelectSingleNode("//HdrXml").Attributes["VendorBill"].Value == "")
            {
                VR.VendorBill = "";
            }
            else
            {

                VR.VendorBill = doc.SelectSingleNode("//HdrXml").Attributes["VendorBill"].Value;
            }
            if (doc.SelectSingleNode("//HdrXml").Attributes["Des"].Value == "")
            {
                VR.Des = "";
            }
            else
            {

                VR.Des = doc.SelectSingleNode("//HdrXml").Attributes["Des"].Value;
            }
            if (doc.SelectSingleNode("//HdrXml").Attributes["Temp"].Value == "")
            {
                VR.Temp = false;
            }
            else
            {

                VR.Temp = Convert.ToBoolean(doc.SelectSingleNode("//HdrXml").Attributes["Temp"].Value);
            }
            command = new SqlCommand();
            if (VR.Id != 0)
            {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:VendorRequesthDAO Update" + ", ProcName:'" + StoredProcedures.VendorRequest_Update;

                    command.CommandText = StoredProcedures.VendorRequest_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = VR.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:VendorRequestDAO Insert" + ", ProcName:'" + StoredProcedures.VendorRequest_Insert;

                    command.CommandText = StoredProcedures.VendorRequest_Insert;
                }

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = VR.PropertyId;
                command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = VR.Property;
                command.Parameters.Add("@CategoryId", SqlDbType.BigInt).Value = VR.CategoryId;
                command.Parameters.Add("@Category", SqlDbType.NVarChar).Value = VR.Category;
                command.Parameters.Add("@VendorId", SqlDbType.BigInt).Value = VR.VendorId;
                command.Parameters.Add("@VendorName", SqlDbType.NVarChar).Value = VR.VendorName;
                command.Parameters.Add("@Service", SqlDbType.NVarChar).Value = VR.Service;
                command.Parameters.Add("@Type", SqlDbType.NVarChar).Value = VR.Type;
                command.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = VR.ApartmentId;
                command.Parameters.Add("@RoomId", SqlDbType.BigInt).Value = VR.RoomId;
                command.Parameters.Add("@Date", SqlDbType.NVarChar).Value = VR.Date;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = VR.Amount;
                command.Parameters.Add("@BillNo", SqlDbType.NVarChar).Value = VR.BillNo;
                command.Parameters.Add("@Duedate", SqlDbType.NVarChar).Value = VR.Duedate;
                command.Parameters.Add("@VendorBill", SqlDbType.NVarChar).Value = VR.VendorBill;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = VR.Des;
                command.Parameters.Add("@Temp", SqlDbType.Bit).Value = VR.Temp;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                command.Parameters.Add("@Status", SqlDbType.NVarChar).Value = "Submitted";
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                return ds;
        }
        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:VendorRequestDAO Select" + ", ProcName:'" + StoredProcedures.VendorRequest_Select;

           SqlCommand command = new SqlCommand();
            //command.CommandText = StoredProcedures.VendorRequest_Select;
            //command.CommandType = CommandType.StoredProcedure;
            //command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:VendorRequestDAO Help" + ", ProcName:'" + StoredProcedures.VendorRequest_Help;

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.VendorRequest_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[4].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
