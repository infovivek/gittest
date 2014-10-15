using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;
namespace HB.Dao
{
    public class ClientGradeCityDetailsDAO
    {
        public DataSet Save(int HdrId ,string Hdrval, User user)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();

            XmlDocument document = new XmlDocument();
            document.LoadXml(Hdrval);
            ClientGradeCityDetails ClientGrd = new ClientGradeCityDetails();
            int n = 0;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {

                if (document.SelectNodes("//GridXml")[i].Attributes["CityId"].Value == "")
                {
                    ClientGrd.CityId = 0;
                }
                else
                {
                    ClientGrd.CityId = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["CityId"].Value);
                }
                ClientGrd.CityName = document.SelectNodes("//GridXml")[i].Attributes["CityName"].Value;

                ClientGrd.ClientGradeCityId = HdrId;

                ClientGrd.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                command = new SqlCommand();
                if (ClientGrd.Id != 0)
                {
                    command.CommandText = StoredProcedures.ClientGradeCityDetails_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = ClientGrd.Id;
                }
                else
                {
                    command.CommandText = StoredProcedures.ClientGradeCityDetails_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@ClientGradeValueId", SqlDbType.BigInt).Value = ClientGrd.ClientGradeCityId;
                command.Parameters.Add("@CityName", SqlDbType.NVarChar).Value = ClientGrd.CityName;
                command.Parameters.Add("@CityId", SqlDbType.BigInt).Value = ClientGrd.CityId;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

                ds = new WrbErpConnection().ExecuteDataSet(command, "");
            }
            return ds;
        }
    }
}
