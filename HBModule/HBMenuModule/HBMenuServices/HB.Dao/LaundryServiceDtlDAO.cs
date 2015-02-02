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
    public class LaundryServiceDtlDAO
    {
        String UserData;
        public DataSet Save(string LaundryHdr, User Usr, int LaundryHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            LaundryServiceDtl LSD = new LaundryServiceDtl();
            document.LoadXml(LaundryHdr);
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {


                LSD.ServiceItem = document.SelectNodes("//ServiceXml")[i].Attributes["ServiceItem"].Value;
                LSD.TypeService = document.SelectNodes("//ServiceXml")[i].Attributes["TypeService"].Value;
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value == "")
                {
                    LSD.Quantity = 0;
                }
                else
                {
                    LSD.Quantity = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value);
                }
                LSD.Price = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["Price"].Value);
                LSD.Amount = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["Amount"].Value);
                if (document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value == "")
                {
                    LSD.ItemId = 0;
                }
                else
                {
                    LSD.ItemId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                {
                    LSD.Id = 0;
                }
                else
                {
                    LSD.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                }

                command = new SqlCommand();
                if (LSD.Id != 0)
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:PCHistroryDAO Help" + ", ProcName:'" + StoredProcedures.LaundryServiceDtl_Update;

                    command.CommandText = StoredProcedures.LaundryServiceDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = LSD.Id;
                }
                else
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:PCHistroryDAO Help" + ", ProcName:'" + StoredProcedures.LaundryServiceDtl_Insert;

                    command.CommandText = StoredProcedures.LaundryServiceDtl_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@LaundryHdrId", SqlDbType.Int).Value = LaundryHdrId;
                command.Parameters.Add("@ServiceItem", SqlDbType.NVarChar).Value = LSD.ServiceItem;
                command.Parameters.Add("@ServiceType", SqlDbType.NVarChar).Value = LSD.TypeService;
                command.Parameters.Add("@Quantity", SqlDbType.Int).Value = LSD.Quantity;
                command.Parameters.Add("@Price", SqlDbType.Decimal).Value = LSD.Price;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = LSD.Amount;
                command.Parameters.Add("@ItemId", SqlDbType.Int).Value = LSD.ItemId;
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
