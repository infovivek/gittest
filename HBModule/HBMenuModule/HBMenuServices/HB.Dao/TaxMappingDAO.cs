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
    public class TaxMappingDAO
    {
        string UserData;
        public DataSet Save(string[] data, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            TaxMapping TM = new TaxMapping();
            XmlDocument doc = new XmlDocument();

            int PropertyId;
            string Property;
            doc.LoadXml(data[1].ToString());

            PropertyId = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["PropertyId"].Value);
            Property = doc.SelectSingleNode("//HdrXml").Attributes["Property"].Value;
            XmlDocument document = new XmlDocument();
            document.LoadXml(data[2].ToString());
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                {
                    TM.Id = 0;
                }
                else
                {
                    TM.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                }
                TM.ServiceItem = document.SelectNodes("//ServiceXml")[i].Attributes["ServiceItem"].Value;
                if (document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value == "")
                {
                    TM.ItemId = 0;
                }
                else
                {
                    TM.ItemId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value);
                }
                TM.VAT = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["VAT"].Value);
                TM.LuxuryTax = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["LuxuryTax"].Value);
                TM.ST1 = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["ST1"].Value);
                TM.ST2 = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["ST2"].Value);
                TM.ST3 = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["ST3"].Value);
                TM.Service = document.SelectNodes("//ServiceXml")[i].Attributes["Service"].Value;


                command = new SqlCommand();
                if (TM.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:TMCashDAO Update" + ", ProcName:'" + StoredProcedures.TaxMapping_Update;

                    command.CommandText = StoredProcedures.TaxMapping_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = TM.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:TMCashDAO Insert" + ", ProcName:'" + StoredProcedures.TaxMapping_Insert;

                    command.CommandText = StoredProcedures.TaxMapping_Insert;
                }

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PropertyId;
                command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = Property;
                command.Parameters.Add("@ServiceItem", SqlDbType.NVarChar).Value = TM.ServiceItem;
                command.Parameters.Add("@ItemId", SqlDbType.BigInt).Value = TM.ItemId;
                command.Parameters.Add("@VAT", SqlDbType.Bit).Value = TM.VAT;
                command.Parameters.Add("@LuxuryTax", SqlDbType.Bit).Value = TM.LuxuryTax;
                command.Parameters.Add("@ST1", SqlDbType.Bit).Value = TM.ST1;
                command.Parameters.Add("@ST2", SqlDbType.Bit).Value = TM.ST2;
                command.Parameters.Add("@ST3", SqlDbType.Bit).Value = TM.ST3;
                command.Parameters.Add("@Service", SqlDbType.NVarChar).Value = TM.Service;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

            }
            return ds;
        }
        public DataSet Help(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                "', SctId:" + user.SctId + ", Service:TMCashDAO Help" + ", ProcName:'" + StoredProcedures.TaxMapping_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.TaxMapping_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

    }
}
