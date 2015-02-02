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
    public class CheckOutServiceDtlsDAO
    {
        string UserData;
        SqlCommand command = new SqlCommand();
        public DataSet Save(string CheckOutServiceDtls, User user, int CheckOutServceHdrId,int CheckOutHdrRowId )
        {
            UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            CheckOutServiceDtls ChkOutSerDtl = new CheckOutServiceDtls();
            DataTable dTable = new DataTable("DBERRORTBL");
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            DataSet ds = new DataSet();
            doc.LoadXml(CheckOutServiceDtls);
            int n;
            
            n = (doc).SelectNodes("//ServiceXml").Count;

            if (n != 0)
            {

                for (int i = 0; i < n; i++)
                {
                    ChkOutSerDtl.Date = doc.SelectNodes("//ServiceXml")[i].Attributes["Date"].Value;
                    ChkOutSerDtl.ProductId = Convert.ToInt32(doc.SelectNodes("//ServiceXml")[i].Attributes["ItemId"].Value);
                    ChkOutSerDtl.TypeService = doc.SelectNodes("//ServiceXml")[i].Attributes["TypeService"].Value;
                    ChkOutSerDtl.ServiceItem = doc.SelectNodes("//ServiceXml")[i].Attributes["ServiceItem"].Value;
                    if (doc.SelectNodes("//ServiceXml")[i].Attributes["Amount"].Value == "")
                    {
                        ChkOutSerDtl.Amount = 0;
                    }
                    else
                    {
                        ChkOutSerDtl.Amount = Convert.ToDecimal(doc.SelectNodes("//ServiceXml")[i].Attributes["Amount"].Value);
                    }
                    if (doc.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                    {
                        ChkOutSerDtl.Id = 0;
                    }
                    else
                    {
                        ChkOutSerDtl.Id = Convert.ToInt32(doc.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                    }
                    if (doc.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value == "")
                    {
                        ChkOutSerDtl.Quantity = 0;
                    }
                    else
                    {
                        ChkOutSerDtl.Quantity = Convert.ToDecimal(doc.SelectNodes("//ServiceXml")[i].Attributes["Quantity"].Value);
                    }

                    command = new SqlCommand();
                    //if (ChkOutSerDtl.Id != 0)
                    //{
                    //    command.CommandText = StoredProcedures.CheckOutHdrServiceDtl_Update;

                    //}
                    //else
                    //{
                    command.CommandText = StoredProcedures.CheckOutHdrServiceDtl_Insert;
                    //}
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ChkOutSerDtl.Id;
                    command.Parameters.Add("@CheckOutServceHdrId", SqlDbType.NVarChar).Value = CheckOutServceHdrId;
                    command.Parameters.Add("@ChkOutSerAction", SqlDbType.Bit).Value = 0;
                    command.Parameters.Add("@ChkOutserInclude", SqlDbType.Bit).Value = 0;
                    command.Parameters.Add("@ChkOutSerDate", SqlDbType.NVarChar).Value = ChkOutSerDtl.Date;
                    command.Parameters.Add("@ChkOutSerItem", SqlDbType.NVarChar).Value = ChkOutSerDtl.ServiceItem;
                    command.Parameters.Add("@ChkOutSerAmount", SqlDbType.Decimal).Value = ChkOutSerDtl.Amount;
                    command.Parameters.Add("@ProductId", SqlDbType.Int).Value = ChkOutSerDtl.ProductId;
                    command.Parameters.Add("@TypeService", SqlDbType.NVarChar).Value = ChkOutSerDtl.TypeService;
                    command.Parameters.Add("@ChkOutSerQuantity", SqlDbType.Int).Value = 0;
                    command.Parameters.Add("@ChkOutSerNetAmount", SqlDbType.Decimal).Value = 0;
                    command.Parameters.Add("@Quantity", SqlDbType.Decimal).Value = ChkOutSerDtl.Quantity;
                    command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                    command.Parameters.Add("@ServiceHdrId", SqlDbType.Int).Value = CheckOutHdrRowId;
                    ds = new WrbErpConnection().ExecuteDataSet(command, "");
                }
            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }
            return ds;

        }
    }
}
