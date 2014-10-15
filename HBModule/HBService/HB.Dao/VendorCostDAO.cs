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
    public class VendorCostDAO
    {
        string UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            VendorCost VC = new VendorCost();
            XmlDocument doc = new XmlDocument();

            int VendorId;
            string EffectiveFrom;
            doc.LoadXml(data[1].ToString());
            VendorId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["VendorId"].Value);
            EffectiveFrom = doc.SelectSingleNode("//HdrXml").Attributes["EffectiveFrom"].Value;

            XmlDocument document = new XmlDocument();
            document.LoadXml(data[2].ToString());

            int n;
            n = (document).SelectNodes("//ServiceXml").Count;

            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                {
                    VC.Id = 0;
                }
                else
                {
                    VC.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value == "")
                {
                    VC.ItemId = 0;
                }
                else
                {
                    VC.ItemId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["ServiceItem"].Value == "")
                {
                    VC.ServiceItem = "";
                }
                else
                {
                    VC.ServiceItem = document.SelectNodes("//ServiceXml")[i].Attributes["ServiceItem"].Value;
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Cost"].Value == "")
                {
                    VC.Cost = 0;
                }
                else
                {
                    VC.Cost = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["Cost"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Flag"].Value == "")
                {
                    VC.Flag = 0;
                }
                else
                {
                    VC.Flag = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Flag"].Value);
                }
                command = new SqlCommand();
                if (VC.Id != 0)
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                        "',SctId:" + user.SctId + ",Service:  VendorCostDao Update" + ",ProcName:'" + StoredProcedures.VendorCost_Update;

                    command.CommandText = StoredProcedures.VendorCost_Update;
                    command.Parameters.Add("@Id", SqlDbType.Int).Value = VC.Id;
                }
                else
                {
                    UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                     "',SctId:" + user.SctId + ",Service:  VendorCostDao Insert" + ",ProcName:'" + StoredProcedures.VendorCost_Insert;

                    command.CommandText = StoredProcedures.VendorCost_Insert;
                }
                command.CommandType = CommandType.StoredProcedure; 
                command.Parameters.Add("@VendorId", SqlDbType.BigInt).Value = VendorId;
                command.Parameters.Add("@EffectiveFrom", SqlDbType.NVarChar).Value = EffectiveFrom;
                command.Parameters.Add("@ItemId", SqlDbType.BigInt).Value = VC.ItemId;
                command.Parameters.Add("@ProductName", SqlDbType.NVarChar).Value = VC.ServiceItem;
                command.Parameters.Add("@Cost", SqlDbType.Decimal).Value = VC.Cost;
                command.Parameters.Add("@Flag", SqlDbType.BigInt).Value = VC.Flag;
                command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                  "',SctId:" + user.SctId + ",Service:  VendorCostDAO  Select" + ",ProcName:'";// +StoredProcedures.VendorCost_Insert;
                  
            MapVendor MP = new MapVendor();
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            //command.CommandText = StoredProcedures. ;
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
            UserData = "  UserId:" + user.Id + ",UsreName:" + user.LoginUserName + ",ScreenName:'" + user.ScreenName +
                "',SctId:" + user.SctId + ",Service:  VendorCostDAO  Help" + ",ProcName:'" + StoredProcedures.VendorCost_Help;
         
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.VendorCost_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[2].ToString());
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[4].ToString();
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
    }
}
