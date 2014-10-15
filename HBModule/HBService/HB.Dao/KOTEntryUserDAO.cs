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
    public class KOTEntryUserDAO
    {
        String UserData;
        public DataSet Save(string KOTEntryHdrUser, User Usr, int KOTEntryHdrId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            SqlCommand command = new SqlCommand();
            KOTEntryUser KOTUser = new KOTEntryUser();
            document.LoadXml(KOTEntryHdrUser);
            int n;
            n = (document).SelectNodes("//ServiceXml").Count;
            for (int i = 0; i < n; i++)
            {
                KOTUser.UserId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["UserId"].Value);
                KOTUser.UserName = document.SelectNodes("//ServiceXml")[i].Attributes["UserName"].Value;
                if (document.SelectNodes("//ServiceXml")[i].Attributes["BreakfastVeg"].Value == "")
                {
                    KOTUser.BreakfastVeg = 0;
                }
                else
                {
                    KOTUser.BreakfastVeg = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["BreakfastVeg"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["BreakfastNonVeg"].Value == "")
                {
                    KOTUser.BreakfastNonVeg = 0;
                }
                else
                {
                    KOTUser.BreakfastNonVeg = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["BreakfastNonVeg"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["LunchVeg"].Value == "")
                {
                    KOTUser.LunchVeg = 0;
                }
                else
                {
                    KOTUser.LunchVeg = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["LunchVeg"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["LunchNonVeg"].Value == "")
                {
                    KOTUser.LunchNonVeg = 0;
                }
                else
                {
                    KOTUser.LunchNonVeg = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["LunchNonVeg"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["DinnerVeg"].Value == "")
                {
                    KOTUser.DinnerVeg = 0;
                }
                else
                {
                    KOTUser.DinnerVeg = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["DinnerVeg"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["DinnerNonVeg"].Value == "")
                {
                    KOTUser.DinnerNonVeg = 0;
                }
                else
                {
                    KOTUser.DinnerNonVeg = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["DinnerNonVeg"].Value);
                }
                if (document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                {
                    KOTUser.Id = 0;
                }
                else
                {
                    KOTUser.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                }

                command = new SqlCommand();
                if (KOTUser.Id != 0)
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:KOTEntryUserDAO Update" + ", ProcName:'" + StoredProcedures.KOTEntryUser_Update; 

                    command.CommandText = StoredProcedures.KOTEntryUser_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = KOTUser.Id;
                }
                else
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:KOTEntryUserDAO Insert" + ", ProcName:'" + StoredProcedures.KOTEntryUser_Insert; 

                    command.CommandText = StoredProcedures.KOTEntryUser_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@KOTEntryHdrId", SqlDbType.Int).Value = KOTEntryHdrId;
                command.Parameters.Add("@UserId", SqlDbType.Int).Value = KOTUser.UserId;
                command.Parameters.Add("@UserName", SqlDbType.NVarChar).Value = KOTUser.UserName;
                command.Parameters.Add("@BreakfastVeg", SqlDbType.Int).Value = KOTUser.BreakfastVeg;
                command.Parameters.Add("@BreakfastNonVeg", SqlDbType.Int).Value = KOTUser.BreakfastNonVeg;
                command.Parameters.Add("@LunchVeg", SqlDbType.Int).Value = KOTUser.LunchVeg;
                command.Parameters.Add("@LunchNonVeg", SqlDbType.Int).Value = KOTUser.LunchNonVeg;
                command.Parameters.Add("@DinnerVeg", SqlDbType.Int).Value = KOTUser.DinnerVeg;
                command.Parameters.Add("@DinnerNonVeg", SqlDbType.Int).Value = KOTUser.DinnerNonVeg;
                command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = Usr.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
           
            {
                ds.Tables.Add(dTable);
                return ds;
            }


        }
    }
}
