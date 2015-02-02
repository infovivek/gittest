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
   public class PropertyOwnerApartmentDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
       public DataSet Save(String ApatmentId, Int32 PrptyOwnerId, string PrtyOwnerApartment, User User)
       {
        //   UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
           PropertyOwnerApartment PrtyOwnAprt = new PropertyOwnerApartment();
           XmlDocument doc = new XmlDocument();
           DataSet ds = new DataSet();
           doc.LoadXml(PrtyOwnerApartment);
           int n;
           n = (doc).SelectNodes("//GridXml").Count;
           for (int i = 0; i < n; i++)
           {
               PrtyOwnAprt.OwnerId = PrptyOwnerId;
               PrtyOwnAprt.ApartmentId = Convert.ToInt32(doc.SelectNodes("//GridXml")[i].Attributes["ApartmentId"].Value);
               PrtyOwnAprt.ApartmentName = doc.SelectNodes("//GridXml")[i].Attributes["ApartmentName"].Value;
               if (doc.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
               {
                   PrtyOwnAprt.Id = 0;
               }
               else
               {
                   PrtyOwnAprt.Id = Convert.ToInt32(doc.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
               }
               Cmd = new SqlCommand();
               if (PrtyOwnAprt.Id != 0)
               {
                   UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                         "', SctId:" + User.SctId + ", Service:PropertyOwnerApartmentDAO Update" + ", ProcName:'" + StoredProcedures.PropertyOwnerApartment_Update; 

                   Cmd.CommandText = StoredProcedures.PropertyOwnerApartment_Update;
                   Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = PrtyOwnAprt.Id;
               }
               else
               {
                   UserData = " UserId:" + User.Id + ", UsreName:" + User.LoginUserName + ", ScreenName:'" + User.ScreenName +
                         "', SctId:" + User.SctId + ", Service:PropertyOwnerApartmentDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyOwnerApartment_Insert; 

                   Cmd.CommandText = StoredProcedures.PropertyOwnerApartment_Insert;
               }
               Cmd.CommandType = CommandType.StoredProcedure;
               Cmd.Parameters.Add("@OwnerId", SqlDbType.BigInt).Value = Convert.ToInt32(PrtyOwnAprt.OwnerId);
               Cmd.Parameters.Add("@ApartmentId", SqlDbType.BigInt).Value = Convert.ToInt32(PrtyOwnAprt.ApartmentId);
               Cmd.Parameters.Add("@ApartmentName", SqlDbType.NVarChar).Value = PrtyOwnAprt.ApartmentName;
               Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = User.Id;
               ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData); 
           }
           return ds;
       } 
    }
}
