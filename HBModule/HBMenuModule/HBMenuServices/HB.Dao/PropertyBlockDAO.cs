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
   public class PropertyBlockDAO
    {
         string UserData;
         public DataSet Save(String PropertyRowId, Int32 PropertyId, string PrtyBlock, User user)
         {
             DataSet ds = new DataSet();
             DataTable dTable = new DataTable("ERRORTBL");
             dTable.Columns.Add("Exception");
             SqlCommand command = new SqlCommand();

             XmlDocument document = new XmlDocument();
             document.LoadXml(PrtyBlock);
             PropertyBlock prptyBlock = new PropertyBlock();
             int n;
              n = (document).SelectNodes("//GridXml").Count;
              for (int i = 0; i < n; i++)
              {

                  prptyBlock.BlockDescription = document.SelectNodes("//GridXml")[i].Attributes["Description"].Value;
                  prptyBlock.BlockName = document.SelectNodes("//GridXml")[i].Attributes["Block"].Value;
                  if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                  {
                      prptyBlock.Id = 0;
                  }
                  else
                  {
                      prptyBlock.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                  }
                  command = new SqlCommand();
                  if (prptyBlock.Id != 0)
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                          "', SctId:" + user.SctId + ", Service:PropertyBlockDAO Update" + ", ProcName:'" + StoredProcedures.PropertyBlock_Update; 

                      command.CommandText = StoredProcedures.PropertyBlock_Update;
                      command.Parameters.Add("@Id", SqlDbType.BigInt).Value = prptyBlock.Id;
                  }
                  else
                  {
                      UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                          "', SctId:" + user.SctId + ", Service:PropertyBlockDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyBlock_Insert; 

                      command.CommandText = StoredProcedures.PropertyBlock_Insert;
                  }
                  command.CommandType = CommandType.StoredProcedure;
                  command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = PropertyId;
                  command.Parameters.Add("@PropertyRowId", SqlDbType.NVarChar).Value = PropertyRowId;
                  command.Parameters.Add("@BlockDescription", SqlDbType.NVarChar).Value = prptyBlock.BlockDescription;
                  command.Parameters.Add("@BlockName", SqlDbType.NVarChar).Value = prptyBlock.BlockName;
                  command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

                  ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
              }
             return ds;
         }

    }
}
