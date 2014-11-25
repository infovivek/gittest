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
    public class VendorRequestDtlDAO
    {
        String UserData;
        public DataSet Save(string VendorRequestHdr, User Usr, int VendorRequestHdrId, int TempSave)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            VendorRequestDtl VendorDtl = new VendorRequestDtl();
            document.LoadXml(VendorRequestHdr);
            int n;
            n = (document).SelectNodes("//HdrXml1").Count;
            for (int i = 0; i < n; i++)
            {
                if (document.SelectNodes("//HdrXml1")[i].Attributes["ApartmentId"].Value == "")
                {
                    VendorDtl.ApartmentId = 0;
                }
                else
                {
                    VendorDtl.ApartmentId = Convert.ToInt32(document.SelectNodes("//HdrXml1")[i].Attributes["ApartmentId"].Value);
                }
                if (document.SelectNodes("//HdrXml1")[i].Attributes["RoomId"].Value == "")
                {
                    VendorDtl.RoomId = 0;
                }
                else
                {
                    VendorDtl.RoomId = Convert.ToInt32(document.SelectNodes("//HdrXml1")[i].Attributes["RoomId"].Value);
                }
                if (document.SelectNodes("//HdrXml1")[i].Attributes["Description"].Value == "")
                {
                    VendorDtl.Description = "";
                }
                else
                {
                    VendorDtl.Description = document.SelectNodes("//HdrXml1")[i].Attributes["Description"].Value;
                }
                if (document.SelectNodes("//HdrXml1")[i].Attributes["BillNo"].Value == "")
                {
                    VendorDtl.BillNo = "";
                }
                else
                {
                    VendorDtl.BillNo = document.SelectNodes("//HdrXml1")[i].Attributes["BillNo"].Value;
                }
                if (document.SelectNodes("//HdrXml1")[i].Attributes["Amount"].Value == "")
                {
                    VendorDtl.Amount = 0;
                }
                else
                {
                    VendorDtl.Amount = Convert.ToDecimal(document.SelectNodes("//HdrXml1")[i].Attributes["Amount"].Value);
                }
                if (document.SelectNodes("//HdrXml1")[i].Attributes["BillNo"].Value == "")
                {
                    VendorDtl.FilePath = "";
                }
                else
                {
                    VendorDtl.FilePath = document.SelectNodes("//HdrXml1")[i].Attributes["FilePath"].Value;
                }
                command = new SqlCommand();
                if (VendorDtl.Id != 0)
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:VendorRequestDtlDAO Help" + ", ProcName:'" + StoredProcedures.VendorRequestDtl_Update;

                    command.CommandText = StoredProcedures.VendorRequestDtl_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = VendorDtl.Id;
                }
                else
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:VendorRequestDtlDAO Help" + ", ProcName:'" + StoredProcedures.VendorRequestDtl_Insert;

                    command.CommandText = StoredProcedures.VendorRequestDtl_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@VendorRequestHdrId", SqlDbType.Int).Value = VendorRequestHdrId;
                command.Parameters.Add("@TempSave", SqlDbType.Int).Value = TempSave;
                command.Parameters.Add("@ApartmentId", SqlDbType.Int).Value = VendorDtl.ApartmentId;
                command.Parameters.Add("@RoomId", SqlDbType.Int).Value = VendorDtl.RoomId;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = VendorDtl.Description;
                command.Parameters.Add("@Filepath", SqlDbType.NVarChar).Value = VendorDtl.FilePath;
                command.Parameters.Add("@BillNo", SqlDbType.NVarChar).Value = VendorDtl.BillNo;
                command.Parameters.Add("@Amount", SqlDbType.NVarChar).Value = VendorDtl.Amount;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = Usr.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
                }
                if (n == 0)
                {
                    ds.Tables.Add(dTable);
                }
            
            return ds;

        }
    }
}
