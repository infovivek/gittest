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
   public class PropertyOwnerOtherContactsDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string OwnerOtherCont, User user, int OwnerId)
        {
        //    UserData = "   UserId : " + user.Id + ", UsreName : " + user.LoginUserName + ", ScreenName : " + user.ScreenName + ", SctId : " + user.SctId + ", BranchId : " + user.BranchId + "";
            PropertyOwnerOtherContacts PrtyOwnOCT = new PropertyOwnerOtherContacts();
            XmlDocument doc = new XmlDocument();
            DataSet ds = new DataSet();
            doc.LoadXml(OwnerOtherCont);
            int n;
            n = (doc).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                PrtyOwnOCT.OwnerId = OwnerId;
                PrtyOwnOCT.Name = doc.SelectNodes("//GridXml")[i].Attributes["Name"].Value;
                PrtyOwnOCT.EmailId = doc.SelectNodes("//GridXml")[i].Attributes["EmailId"].Value;
                PrtyOwnOCT.ContactType = doc.SelectNodes("//GridXml")[i].Attributes["ContactType"].Value;
                PrtyOwnOCT.PhoneNumber = doc.SelectNodes("//GridXml")[i].Attributes["PhoneNumber"].Value;
                PrtyOwnOCT.designation = doc.SelectNodes("//GridXml")[i].Attributes["designation"].Value; 
                if (doc.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                {
                    PrtyOwnOCT.Id = 0;
                }
                else
                {
                    PrtyOwnOCT.Id = Convert.ToInt32(doc.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                }
                Cmd = new SqlCommand();
                if (PrtyOwnOCT.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                         "', SctId:" + user.SctId + ", Service:PropertyOwnerOtherContactsDAO Update" + ", ProcName:'" + StoredProcedures.PropertyOwnerOthersContacts_Update; 

                    Cmd.CommandText = StoredProcedures.PropertyOwnerOthersContacts_Update;
                    Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = PrtyOwnOCT.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                         "', SctId:" + user.SctId + ", Service:PropertyOwnerOtherContactsDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyOwnerOthersContacts_Insert; 

                    Cmd.CommandText = StoredProcedures.PropertyOwnerOthersContacts_Insert;
                }
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Parameters.Add("@OwnerId", SqlDbType.BigInt).Value = Convert.ToInt32(PrtyOwnOCT.OwnerId);
                Cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = PrtyOwnOCT.Name;
                Cmd.Parameters.Add("@EmailId", SqlDbType.NVarChar).Value = PrtyOwnOCT.EmailId;
                Cmd.Parameters.Add("@ContactType", SqlDbType.NVarChar).Value = PrtyOwnOCT.ContactType;
                Cmd.Parameters.Add("@PhoneNumber", SqlDbType.NVarChar).Value = PrtyOwnOCT.PhoneNumber;
                Cmd.Parameters.Add("@designation", SqlDbType.NVarChar).Value = PrtyOwnOCT.designation;              
                Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            }
            return ds;
        } 
    }
}
