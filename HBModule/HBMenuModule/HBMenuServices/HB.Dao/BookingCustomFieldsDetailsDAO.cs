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
    public class BookingCustomFieldsDetailsDAO
    {
        public DataSet Save(string CustomFieldsDetails, User user, int BookingId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            XmlDocument document = new XmlDocument();
            BookingCustomFieldsDetails bookingCF = new BookingCustomFieldsDetails();
            document.LoadXml(CustomFieldsDetails);
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                
                bookingCF.CustomFieldsId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["CustomFieldsId"].Value);
                bookingCF.CustomFields = document.SelectNodes("//GridXml")[i].Attributes["CustomFields"].Value;
                bookingCF.CustomFieldsValue = document.SelectNodes("//GridXml")[i].Attributes["CustomFieldsValue"].Value;
                bookingCF.Mandatory = document.SelectNodes("//GridXml")[i].Attributes["Mandatory"].Value;
                if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                {
                    bookingCF.Id = 0;
                }
                else
                {
                    bookingCF.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                }
                command = new SqlCommand();
                if (bookingCF.Id != 0)
                {
                    command.CommandText = StoredProcedures.BookingCustomFieldsDetails_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = bookingCF.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.BookingCustomFieldsDetails_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
                command.Parameters.Add("@CustomFieldsId", SqlDbType.BigInt).Value = bookingCF.CustomFieldsId;
                command.Parameters.Add("@CustomFields", SqlDbType.NVarChar).Value = bookingCF.CustomFields;
                command.Parameters.Add("@CustomFieldsValue", SqlDbType.NVarChar).Value = bookingCF.CustomFieldsValue;
                command.Parameters.Add("@Mandatory", SqlDbType.NVarChar).Value = bookingCF.Mandatory;               
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, "");
            }
            if (n == 0)
            {
                DataTable dT = new DataTable("DBERRORTBL");
                ds.Tables.Add(dT);
            }
            return ds;

        }
    }
}
