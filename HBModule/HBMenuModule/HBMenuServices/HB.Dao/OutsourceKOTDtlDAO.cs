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
    public class OutsourceKOTDtlDAO
    {
        String UserData;
        public DataSet Save(string OutsourceKOTHdr, User Usr, int OutsourceKOTHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            OutsourceKOTDtl NewKOTDtl = new OutsourceKOTDtl();
            document.LoadXml(OutsourceKOTHdr);
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {


                NewKOTDtl.ServiceItem = document.SelectNodes("//ServiceXml")[i].Attributes["ServiceItem"].Value;
                //    NewKOTDtl.Quantity = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value);
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value == "")
                {
                    NewKOTDtl.Quantity = 0;
                }
                else
                {
                    NewKOTDtl.Quantity = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value);
                }
                NewKOTDtl.Price = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["Price"].Value);
                NewKOTDtl.Amount = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["Amount"].Value);
                if (document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value == "")
                {
                    NewKOTDtl.ItemId = 0;
                }
                else
                {
                    NewKOTDtl.ItemId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                {
                    NewKOTDtl.Id = 0;
                }
                else
                {
                    NewKOTDtl.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                }

                command = new SqlCommand();
                if (NewKOTDtl.Id != 0)
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:OutsourceKOTDtl Help" + ", ProcName:'" + StoredProcedures.OutsourceKOTDtl_Update;

                    command.CommandText = StoredProcedures.OutsourceKOTDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = NewKOTDtl.Id;
                }
                else
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:OutsourceKOTDtl Help" + ", ProcName:'" + StoredProcedures.OutsourceKOTDtl_Insert;

                    command.CommandText = StoredProcedures.OutsourceKOTDtl_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@OutsourceKOTHdrId", SqlDbType.Int).Value = OutsourceKOTHdrId;
                command.Parameters.Add("@ServiceItem", SqlDbType.NVarChar).Value = NewKOTDtl.ServiceItem;
                command.Parameters.Add("@Quantity", SqlDbType.Int).Value = NewKOTDtl.Quantity;
                command.Parameters.Add("@Price", SqlDbType.Decimal).Value = NewKOTDtl.Price;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = NewKOTDtl.Amount;
                command.Parameters.Add("@ItemId", SqlDbType.Int).Value = NewKOTDtl.ItemId;
                //  command.Parameters.Add("@Id", SqlDbType.Int).Value = NewKOTDtl.Id;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = Usr.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

                if (n == 0)
                {
                    ds.Tables.Add(dTable);
                }
            }
            return ds;

        }
    }
}
