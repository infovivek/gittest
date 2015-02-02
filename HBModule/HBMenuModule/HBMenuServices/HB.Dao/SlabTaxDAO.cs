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
    public class SlabTaxDAO
    {
        string UserData;
        public DataSet Save(string[] data, Entity.User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(data[1].ToString());
            SlabTaxEntity ST = new SlabTaxEntity();

            ST.Id =Convert.ToInt32(document.SelectSingleNode("//HdrXml").Attributes["Id"].Value);

            ST.SlabFrom1 =Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabFrom1"].Value);
            ST.SlabTo1 = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTo1"].Value);
            ST.SlabTax1 = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTax1"].Value);

            ST.SlabFrom2=Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabFrom2"].Value);
            ST.SlabTo2= Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTo2"].Value);
            ST.SlabTax2=Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTax2"].Value);

            ST.SlabFrom3=Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabFrom3"].Value);
            ST.SlabTo3= Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTo3"].Value);
            ST.SlabTax3=Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTax3"].Value);


            if (document.SelectSingleNode("//HdrXml").Attributes["SlabFrom4"].Value == "")
            {
                ST.SlabFrom4 = 0;
            }
            else
            {
                ST.SlabFrom4 = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabFrom4"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["SlabTo4"].Value == "")
            {
                ST.SlabTo4 = 0;
            }
            else
            {
                ST.SlabTo4 = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTo4"].Value);
            }
            if (document.SelectSingleNode("//HdrXml").Attributes["SlabTax4"].Value == "")
            {
                ST.SlabTax4 = 0;
            }
            else
            {
                ST.SlabTax4 = Convert.ToDecimal(document.SelectSingleNode("//HdrXml").Attributes["SlabTax4"].Value);
            }
            
            

            if (ST.Id != 0)
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:SlabTaxDAO Update" + ", ProcName:'" + StoredProcedures.SlabTax_Update; 


                command.CommandText = StoredProcedures.SlabTax_Update;
                command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ST.Id;
            }
            else
            {
                UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                    "', SctId:" + user.SctId + ", Service:SlabTaxDAO Insert" + ", ProcName:'" + StoredProcedures.SlabTax_Insert; 

                command.CommandText = StoredProcedures.SlabTax_Insert;
            }
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@SlabFrom1", SqlDbType.BigInt).Value = ST.SlabFrom1;
            command.Parameters.Add("@SlabTo1", SqlDbType.BigInt).Value = ST.SlabTo1;
            command.Parameters.Add("@SlabTax1", SqlDbType.BigInt).Value = ST.SlabTax1;

            command.Parameters.Add("@SlabFrom2", SqlDbType.BigInt).Value = ST.SlabFrom2;
            command.Parameters.Add("@SlabTo2", SqlDbType.BigInt).Value = ST.SlabTo2;
            command.Parameters.Add("@SlabTax2", SqlDbType.BigInt).Value = ST.SlabTax2;

            command.Parameters.Add("@SlabFrom3", SqlDbType.BigInt).Value = ST.SlabFrom3;
            command.Parameters.Add("@SlabTo3", SqlDbType.BigInt).Value = ST.SlabTo3;
            command.Parameters.Add("@SlabTax3", SqlDbType.BigInt).Value = ST.SlabTax3;

            command.Parameters.Add("@SlabFrom4", SqlDbType.BigInt).Value = ST.SlabFrom4;
            command.Parameters.Add("@SlabTo4", SqlDbType.BigInt).Value = ST.SlabTo4;
            command.Parameters.Add("@SlabTax4", SqlDbType.BigInt).Value = ST.SlabTax4;

            command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
            ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            return ds;
        }

        public DataSet Search(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:SlabTaxDAO Search" + ", ProcName:'" + StoredProcedures.SlabTax_Select; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.SlabTax_Select;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.Int).Value = Convert.ToInt32(user.Id);
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Delete(string[] data, Entity.User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:SlabTaxDAO Delete" + ", ProcName:'" + StoredProcedures.SlabTax_Delete; 

            SqlCommand command = new SqlCommand();
            command.CommandText = StoredProcedures.SlabTax_Delete;
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add("@Id", SqlDbType.BigInt).Value = Convert.ToInt32(data[1].ToString());
            command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = user.Id;
            return new WrbErpConnection().ExecuteDataSet(command, UserData);
        }

        public DataSet Help(string[] data, User user)
        {
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:SlabTaxDAO  Help" + ", Nil:'";

            throw new NotImplementedException();
        }
    }
}
