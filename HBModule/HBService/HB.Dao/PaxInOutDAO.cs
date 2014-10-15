using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Xml;
using HB.Entity;

namespace HB.Dao
{
    public class PaxInOutDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                "', SctId:" + User.SctId + ", Service:PCHistroryDAO Help" + ", ProcName:'" + StoredProcedures.PCHistory_Help;
            PaxInOut InOut = new PaxInOut();
            XmlDocument doc = new XmlDocument(); 
            
            doc.LoadXml(data[1]);
            InOut.ChkInHdrId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["ChkInHdrId"].Value);
            InOut.RoomId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["RoomId"].Value);
            InOut.InOut = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["InOut"].Value);
            InOut.Date = doc.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            InOut.Time = doc.SelectSingleNode("HdrXml").Attributes["Time"].Value;
            InOut.Male = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Male"].Value);
            InOut.Female = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Female"].Value);
            InOut.Child = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Child"].Value);
            InOut.Tariff = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Tariff"].Value);
            InOut.Tax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Tax"].Value);
            InOut.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            InOut.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            InOut.VAT = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value);
            InOut.Luxury = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Luxury"].Value);
            InOut.ServiceTax = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceTax"].Value);
            InOut.ExtraBed = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ExtraBed"].Value);
            InOut.TaxId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["TaxId"].Value);
            InOut.PropertyId = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
            InOut.Property = doc.SelectSingleNode("HdrXml").Attributes["Property"].Value;
            InOut.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Cmd = new SqlCommand();
            if (InOut.Id != 0)
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
            "', SctId:" + User.SctId + ", Service:PaxInOutDAO Update" + ", ProcName:'" + StoredProcedures.PaxInOut_Update;
    
                Cmd.CommandText = StoredProcedures.PaxInOut_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = InOut.Id;
            }
            else
            {
                UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
       "', SctId:" + User.SctId + ", Service:PaxInOutDAO Insert" + ", ProcName:'" + StoredProcedures.PaxInOut_Insert;
    
                Cmd.CommandText = StoredProcedures.PaxInOut_Insert;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@ChkInHdrId", SqlDbType.Int).Value = InOut.ChkInHdrId;
            Cmd.Parameters.Add("@RoomId", SqlDbType.Int).Value = InOut.RoomId;
            Cmd.Parameters.Add("@InOut", SqlDbType.Bit).Value = InOut.InOut;
            Cmd.Parameters.Add("@Date", SqlDbType.NVarChar).Value = InOut.Date;
            Cmd.Parameters.Add("@Time", SqlDbType.NVarChar).Value = InOut.Time;
            Cmd.Parameters.Add("@Male", SqlDbType.Int).Value = InOut.Male;
            Cmd.Parameters.Add("@Female", SqlDbType.Int).Value = InOut.Female;
            Cmd.Parameters.Add("@Child", SqlDbType.Int).Value = InOut.Child;
            Cmd.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = InOut.Tariff;
            Cmd.Parameters.Add("@Tax", SqlDbType.Decimal).Value = InOut.Tax;
            Cmd.Parameters.Add("@Cess", SqlDbType.Decimal).Value = InOut.Cess;
            Cmd.Parameters.Add("@HECess", SqlDbType.Decimal).Value = InOut.HECess;
            Cmd.Parameters.Add("@VAT", SqlDbType.Decimal).Value = InOut.VAT;
            Cmd.Parameters.Add("@Luxury", SqlDbType.Decimal).Value = InOut.Luxury;
            Cmd.Parameters.Add("@ExtraBed", SqlDbType.Decimal).Value = InOut.ExtraBed;
            Cmd.Parameters.Add("@ServiceTax", SqlDbType.Decimal).Value = InOut.ServiceTax;
            Cmd.Parameters.Add("@TaxId", SqlDbType.Int).Value = InOut.TaxId;
            Cmd.Parameters.Add("@PropertyId", SqlDbType.Int).Value = InOut.PropertyId;
            Cmd.Parameters.Add("@Property", SqlDbType.NVarChar).Value = InOut.Property;
            Cmd.Parameters.Add("@UsrId", SqlDbType.Int).Value = User.Id;

            Cmd.Parameters.Add("@OldMale", SqlDbType.Int).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["OldMale"].Value);
            Cmd.Parameters.Add("@OldFemale", SqlDbType.Int).Value = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["OldFemale"].Value);
            Cmd.Parameters.Add("@OldTariff", SqlDbType.Decimal).Value = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["OldTariff"].Value);
            Cmd.Parameters.Add("@OldTax", SqlDbType.Decimal).Value = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["OldTax"].Value);
            Cmd.Parameters.Add("@RoomNo", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["RoomNo"].Value;
            Cmd.Parameters.Add("@RoomType", SqlDbType.NVarChar).Value = doc.SelectSingleNode("HdrXml").Attributes["RoomType"].Value;

            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);

           

            return Value;
        }

        public DataSet Search(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
               "', SctId:" + User.SctId + ", Service:PaxInOutDAO Select" + ", ProcName:'" + StoredProcedures.PaxInOut_Select;
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.PaxInOut_Select;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Help(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
               "', SctId:" + User.SctId + ", Service:PaxInOutDAO Help" + ", ProcName:'" + StoredProcedures.PaxInOut_Help;
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.PaxInOut_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            Cmd.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            Cmd.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            Cmd.Parameters.Add("@Id3", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
              "', SctId:" + User.SctId + ", Service:PaxInOutDAO " + ", Nil:'";
            //Cmd = new SqlCommand();
            //Cmd.CommandText = StoredProcedures.PaxInOut_Delete;
            //Cmd.CommandType = CommandType.StoredProcedure;
            //Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //Cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(User.Id);
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }
    }
}
