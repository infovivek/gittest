using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using HB.Entity;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using System.Collections;


namespace HB.Dao
{
   public class ContractManagementServicesDao
    {
       public DataSet Save(string data, User user, int ContractId)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();
           ContractManagementServices CtrtServ = new ContractManagementServices(); 
           XmlDocument document = new XmlDocument();
           document.LoadXml(data);
            int n;
              n = (document).SelectNodes("//ServiceXml").Count;
              for (int i = 0; i < n; i++)
              {
                  CtrtServ.EffectiveFrom = document.SelectNodes("//ServiceXml")[i].Attributes["EffectiveFrom"].Value;
                  CtrtServ.Complimentary = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["Complimentary"].Value);
                  CtrtServ.ServiceName = document.SelectNodes("//ServiceXml")[i].Attributes["ServiceName"].Value;
                  CtrtServ.Price = Convert.ToDecimal(document.SelectNodes("//ServiceXml")[i].Attributes["Price"].Value);
                  CtrtServ.ProductId = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["ProductId"].Value);
                  CtrtServ.Enable = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["Enable"].Value);
                  CtrtServ.AmountChange = Convert.ToBoolean(document.SelectNodes("//ServiceXml")[i].Attributes["AmountChange"].Value);
                  CtrtServ.TypeService = document.SelectNodes("//ServiceXml")[i].Attributes["TypeService"].Value;
                  if (document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value == "")
                  {
                      CtrtServ.Id = 0;
                  }
                  else
                  {
                      CtrtServ.Id = Convert.ToInt32(document.SelectNodes("//ServiceXml")[i].Attributes["Id"].Value);
                  }
                  command = new SqlCommand();
                  if (CtrtServ.Id != 0)
                  {
                      command.CommandText = StoredProcedures.ContractManagementServices_Update;
                      command.Parameters.Add("@Id", SqlDbType.BigInt).Value = CtrtServ.Id;
                  }
                  else
                  {
                      command.CommandText = StoredProcedures.ContractManagementServices_Insert;
                  }
                  command.CommandType = CommandType.StoredProcedure;
                  command.Parameters.Add("@ContractId", SqlDbType.BigInt).Value = ContractId;
                  command.Parameters.Add("@EffectiveFrom", SqlDbType.NVarChar).Value = CtrtServ.EffectiveFrom;
                  command.Parameters.Add("@Complimentary", SqlDbType.Bit).Value = CtrtServ.Complimentary;
                  command.Parameters.Add("@Enable", SqlDbType.Bit).Value = CtrtServ.Enable;
                  command.Parameters.Add("@ServiceName", SqlDbType.NVarChar).Value = CtrtServ.ServiceName;//Productname
                  command.Parameters.Add("@Price", SqlDbType.Decimal).Value = Convert.ToInt32(CtrtServ.Price);
                  command.Parameters.Add("@ProductId", SqlDbType.BigInt).Value = Convert.ToInt32(CtrtServ.ProductId);
                  command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;
                  command.Parameters.Add("@AmountChange", SqlDbType.BigInt).Value = CtrtServ.AmountChange;
                  command.Parameters.Add("@TypeService", SqlDbType.NVarChar).Value = CtrtServ.TypeService;
                  // EffectiveFrom      Complimentary      ServiceName  Price       ProductId           Id 
                  ds = new WrbErpConnection().ExecuteDataSet(command, "");
              }
              if (n == 0)
              {
                  ds.Tables.Add(dTable);
              }
         
           return ds;
       }
    }
}
