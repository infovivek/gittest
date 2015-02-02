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
    public class CompanyMasterDAO
    {
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            CompanyMasterEntity Comp = new CompanyMasterEntity();
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(data[2].ToString());

            Comp.Id = Convert.ToInt32(doc.SelectSingleNode("//HdrXml").Attributes["Id"].Value);
            Comp.LegalCompanyName = doc.SelectSingleNode("//HdrXml").Attributes["LegalCompanyName"].Value;
            Comp.CompanyShortName = doc.SelectSingleNode("//HdrXml").Attributes["CompanyShortName"].Value;
            Comp.Address = doc.SelectSingleNode("//HdrXml").Attributes["Address"].Value;
            Comp.City = doc.SelectSingleNode("//HdrXml").Attributes["City"].Value;
            Comp.State = doc.SelectSingleNode("//HdrXml").Attributes["StateId"].Value;
            Comp.Phone = doc.SelectSingleNode("//HdrXml").Attributes["Phone"].Value;
            Comp.Email = doc.SelectSingleNode("//HdrXml").Attributes["Email"].Value;
            Comp.PanCardNo = doc.SelectSingleNode("//HdrXml").Attributes["PanCardNo"].Value;
            Comp.Logo = doc.SelectSingleNode("//HdrXml").Attributes["ImageName"].Value;

            if (Comp.Id != 0)
            {
                command.CommandText = StoredProcedures.CompanyMaster_Update;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = Comp.Id;
            }
            else
            {
                command.CommandText = StoredProcedures.CompanyMaster_Insert;
            }

            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@LegalCompanyName", SqlDbType.NVarChar).Value = Comp.LegalCompanyName;
            command.Parameters.Add("@CompanyShortName", SqlDbType.NVarChar).Value = Comp.CompanyShortName;
            command.Parameters.Add("@Address", SqlDbType.NVarChar).Value = Comp.Address;
            command.Parameters.Add("@City", SqlDbType.BigInt).Value = Comp.City;
            command.Parameters.Add("@State", SqlDbType.Int).Value = Comp.State;
            command.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = Comp.Phone;
            command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Comp.Email;
            command.Parameters.Add("@PanCardNo", SqlDbType.NVarChar).Value = Comp.PanCardNo;
            command.Parameters.Add("@Logo", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("CreatedBy", SqlDbType.BigInt).Value = user.Id;
            command.Parameters.Add("@ImageName", SqlDbType.NVarChar).Value = Comp.Logo;
            ds = new WrbErpConnection().ExecuteDataSet(command, "");
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.CompanyMaster_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            //command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet Delete(string[] data, Entity.User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.CompanyMaster_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = data[1].ToString();
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
        public DataSet HelpResult(string[] data, User user)
        {
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = StoredProcedures.CompanyMaster_Help;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@Id1", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            command.Parameters.Add("@Id2", SqlDbType.Int).Value = Convert.ToInt32(data[5].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, "");
        }
    }
}


