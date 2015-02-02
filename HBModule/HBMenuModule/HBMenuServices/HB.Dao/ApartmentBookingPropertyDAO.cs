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
    public class ApartmentBookingPropertyDAO
    {
        String UserData;
        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                   "', SctId:" + user.SctId + ", Service:ApartmentBookingPropertyDAO Help" + ", ProcName:'" + StoredProcedures.ApartmentBooking_Help; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.ApartmentBooking_Help;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            command.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            command.Parameters.Add("@Str2", SqlDbType.NVarChar).Value = data[3].ToString();
            command.Parameters.Add("@ChkInDt", SqlDbType.NVarChar).Value = data[4].ToString();
            command.Parameters.Add("@ChkOutDt", SqlDbType.NVarChar).Value = data[5].ToString();
            command.Parameters.Add("@StateId", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
            command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = Convert.ToInt32(data[7].ToString());
            command.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = Convert.ToInt32(data[8].ToString());
            command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[9].ToString());
            command.Parameters.Add("@GradeId", SqlDbType.BigInt).Value = Convert.ToInt32(data[10].ToString());
            command.Parameters.Add("@Id1", SqlDbType.BigInt).Value = Convert.ToInt32(data[11].ToString());
            command.Parameters.Add("@Id2", SqlDbType.BigInt).Value = Convert.ToInt32(data[12].ToString());
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }
        public DataSet Save(string BedBookingProperty, User Usr, int BookingId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            XmlDocument document = new XmlDocument();
            ApartmentBookingProperty BookPty = new ApartmentBookingProperty();
            document.LoadXml(BedBookingProperty);
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                BookPty.PropertyName = document.SelectNodes("//GridXml")[i].Attributes["PropertyName"].Value;
                BookPty.PropertyId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["PropertyId"].Value);
                BookPty.GetType = document.SelectNodes("//GridXml")[i].Attributes["GetType"].Value;
                BookPty.PropertyType = document.SelectNodes("//GridXml")[i].Attributes["PropertyType"].Value;
                BookPty.Tariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Tariff"].Value);
                if (document.SelectNodes("//GridXml")[i].Attributes["Discount"].Value == "")
                {
                    BookPty.Discount = 0;
                }
                else
                {
                    BookPty.Discount = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Discount"].Value);
                }                
                BookPty.DiscountedTariff = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DiscountedTariff"].Value);
                BookPty.Phone = document.SelectNodes("//GridXml")[i].Attributes["Phone"].Value;
                BookPty.Email = document.SelectNodes("//GridXml")[i].Attributes["Email"].Value;
                BookPty.Locality = document.SelectNodes("//GridXml")[i].Attributes["Locality"].Value;
                BookPty.LocalityId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["LocalityId"].Value);
                BookPty.Rs = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["Rs"].Value);
                BookPty.Per = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["Per"].Value);
                BookPty.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                BookPty.DiscountAllowed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["DiscountAllowed"].Value);
                SqlCommand command = new SqlCommand();
                if (BookPty.Id == 0)
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                        "', SctId:" + Usr.SctId + ", Service:ApartmentBookingPropertyDAO Insert" + ", ProcName:'" + StoredProcedures.ApartmentBookingProperty_Insert; 

                    command.CommandText = StoredProcedures.ApartmentBookingProperty_Insert;
                }
                else
                {
                    UserData = " UserId:" + Usr.Id + ", UsreName:" + Usr.LoginUserName + ", ScreenName:'" + Usr.ScreenName +
                    "', SctId:" + Usr.SctId + ", Service:ApartmentBookingPropertyDAO Update" + ", Nil:'";// +StoredProcedures.ApartmentBookingProperty_Insert; 

                    //command.CommandText = StoredProcedures.BookingProperty_Update;
                    //command.Parameters.Add("@Id", SqlDbType.BigInt).Value = BookPty.Id;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@BookingId", SqlDbType.BigInt).Value = BookingId;
                command.Parameters.Add("@PropertyName", SqlDbType.NVarChar).Value = BookPty.PropertyName;
                command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = BookPty.PropertyId;
                command.Parameters.Add("@GetType", SqlDbType.NVarChar).Value = BookPty.GetType;
                command.Parameters.Add("@PropertyType", SqlDbType.NVarChar).Value = BookPty.PropertyType;
                command.Parameters.Add("@Tariff", SqlDbType.Decimal).Value = BookPty.Tariff;
                command.Parameters.Add("@Discount", SqlDbType.Decimal).Value = BookPty.Discount;
                command.Parameters.Add("@DiscountedTariff", SqlDbType.Decimal).Value = BookPty.DiscountedTariff;
                command.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = BookPty.Phone;
                command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = BookPty.Email;
                command.Parameters.Add("@Locality", SqlDbType.NVarChar).Value = BookPty.Locality;
                command.Parameters.Add("@LocalityId", SqlDbType.BigInt).Value = BookPty.LocalityId;
                command.Parameters.Add("@Rs", SqlDbType.Bit).Value = BookPty.Rs;
                command.Parameters.Add("@Per", SqlDbType.Bit).Value = BookPty.Per;
                command.Parameters.Add("@DiscountAllowed", SqlDbType.Decimal).Value = BookPty.DiscountAllowed;
                command.Parameters.Add("@UsrId", SqlDbType.BigInt).Value = Usr.Id;
                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
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
