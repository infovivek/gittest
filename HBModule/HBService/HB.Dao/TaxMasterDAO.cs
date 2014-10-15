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
    public class TaxMasterDAO
    {
        string UserData;
        SqlCommand Cmd = new SqlCommand();
        public DataSet Save(string[] data, User User)
        {
            UserData = "   UserId : " + User.Id + ", UsreName : " + User.LoginUserName + ", ScreenName : " + User.ScreenName + ", SctId : " + User.SctId + ", BranchId : " + User.BranchId + "";
            TAxMaster Tax = new TAxMaster();
            XmlDocument doc = new XmlDocument();
            string Mode = "";
            doc.LoadXml(data[1]);
            //Cess
            if (doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value == "")
            {
                Tax.Cess = 0;
            }
            else
            {
                Tax.Cess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Cess"].Value);
            }
            //HECess
            if (doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value == "")
            {
               Tax.HECess = 0;
            }
            else
            {
                Tax.HECess = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["HECess"].Value);
            }
            //VAT
            if (doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value == "")
            {
               Tax.VAT = 0;
            }
            else
            {
                Tax.VAT = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["VAT"].Value);
            }//FoodTax
            if (doc.SelectSingleNode("HdrXml").Attributes["ServiceAmount"].Value == "")
            {
               Tax.ServiceAmount = 0;
            }
            else
            {
                Tax.ServiceAmount = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["ServiceAmount"].Value);
            }//resservice
            if (doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value == "")
            {
                Tax.RestaurantST = 0;
            }
            else
            {
                Tax.RestaurantST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["RestaurantST"].Value);
            }
            if (doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value == "")
            {
                Tax.BusinessSupportST = 0;
            }
            else
            {
                Tax.BusinessSupportST = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["BusinessSupportST"].Value);
            }//TariffAmtFrom
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom"].Value == "")
            {
                Tax.TariffAmtFrom = 0;
            }
            else
            {
                Tax.TariffAmtFrom = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom"].Value);
            }//TariffAmtTo
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo"].Value == "")
            {
                Tax.TariffAmtTo = 0;
            }
            else
            {
                Tax.TariffAmtTo = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo"].Value);
            }//Taxper
            if (doc.SelectSingleNode("HdrXml").Attributes["Taxper"].Value == "")
            {
                Tax.Taxper = 0;
            }
            else
            {
                Tax.Taxper = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Taxper"].Value);
            }//TariffAmtFrom1
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom1"].Value == "")
            {
                Tax.TariffAmtFrom1 = 0;
            }
            else
            {
                Tax.TariffAmtFrom1 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom1"].Value);
            }//TariffAmtTo1
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo1"].Value == "")
            {
                Tax.TariffAmtTo1 = 0;
            }
            else
            {
                Tax.TariffAmtTo1 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo1"].Value);
            }//Taxper1
            if (doc.SelectSingleNode("HdrXml").Attributes["Taxper1"].Value == "")
            {
                Tax.Taxper1 = 0;
            }
            else
            {
                Tax.Taxper1 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Taxper1"].Value);
            }//TariffAmtFrom2
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom2"].Value == "")
            {
                Tax.TariffAmtFrom2 = 0;
            }
            else
            {
                Tax.TariffAmtFrom2 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom2"].Value);
            }//TariffAmtTo2
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo2"].Value == "")
            {
                Tax.TariffAmtTo2 = 0;
            }
            else
            {
                Tax.TariffAmtTo2 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo2"].Value);
            }//Taxper2
            if (doc.SelectSingleNode("HdrXml").Attributes["Taxper2"].Value == "")
            {
                Tax.Taxper2 = 0;
            }
            else
            {
                Tax.Taxper2 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Taxper2"].Value);
            }//TariffAmtFrom3
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom3"].Value == "")
            {
                Tax.TariffAmtFrom3 = 0;
            }
            else
            {
                Tax.TariffAmtFrom3 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtFrom3"].Value);
            }//TariffAmtTo3
            if (doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo3"].Value == "")
            {
                Tax.TariffAmtTo3 = 0;
            }
            else
            {
                Tax.TariffAmtTo3 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["TariffAmtTo3"].Value);
            }//Taxper3
            if (doc.SelectSingleNode("HdrXml").Attributes["Taxper3"].Value == "")
            {
                Tax.Taxper3 = 0;
            }
            else
            {
                Tax.Taxper3 = Convert.ToDecimal(doc.SelectSingleNode("HdrXml").Attributes["Taxper3"].Value);
            }
            Tax.VATNo = doc.SelectSingleNode("HdrXml").Attributes["VATNo"].Value;
            Tax.LuxuryNo = doc.SelectSingleNode("HdrXml").Attributes["LuxuryNo"].Value;
            Tax.ServiceNo = doc.SelectSingleNode("HdrXml").Attributes["ServiceNo"].Value;
            Tax.State = doc.SelectSingleNode("HdrXml").Attributes["State"].Value;
            Tax.StateId =  Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["StateId"].Value);
            Tax.Date = doc.SelectSingleNode("HdrXml").Attributes["Date"].Value;
            Tax.RackTariff = Convert.ToBoolean(doc.SelectSingleNode("HdrXml").Attributes["RackTariff"].Value);
            Tax.Id = Convert.ToInt32(doc.SelectSingleNode("HdrXml").Attributes["Id"].Value);
            Tax.TINNumber = doc.SelectSingleNode("HdrXml").Attributes["TINNumber"].Value;
            Tax.CINNumber = doc.SelectSingleNode("HdrXml").Attributes["CINNumber"].Value;
            Cmd = new SqlCommand();
            if (Tax.Id != 0)
            {
                UserData = "  UserId:" + User.Id + ",UsreName:" + User.LoginUserName + ",ScreenName:'" + User.ScreenName +
                   "',SctId:" + User.SctId + ",Service:  TaxMasterDAO  save" + ",ProcName:'" + StoredProcedures.TaxMaster_Update;

                Mode = "Update";
                Cmd.CommandText = StoredProcedures.TaxMaster_Update;
                Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Tax.Id;
            }
            else
            {
                UserData = "  UserId:" + User.Id + ",UsreName:" + User.LoginUserName + ",ScreenName:'" + User.ScreenName +
                   "',SctId:" + User.SctId + ",Service:  TaxMasterDAO  Update" + ",ProcName:'" + StoredProcedures.TaxMaster_Insert;

                Mode = "Save";
                Cmd.CommandText = StoredProcedures.TaxMaster_Insert;
            }
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Cess", SqlDbType.Decimal).Value = Tax.Cess;
            Cmd.Parameters.Add("@HECess", SqlDbType.Decimal).Value = Tax.HECess;
            Cmd.Parameters.Add("@VAT", SqlDbType.Decimal).Value = Tax.VAT;
            Cmd.Parameters.Add("@ServiceAmount", SqlDbType.Decimal).Value = Tax.ServiceAmount;
            Cmd.Parameters.Add("@TariffAmtFrom", SqlDbType.Decimal).Value = Tax.TariffAmtFrom;
            Cmd.Parameters.Add("@TariffAmtTo", SqlDbType.Decimal).Value = Tax.TariffAmtTo;
            Cmd.Parameters.Add("@Taxper", SqlDbType.Decimal).Value = Tax.Taxper;
            Cmd.Parameters.Add("@TariffAmtFrom1", SqlDbType.Decimal).Value = Tax.TariffAmtFrom1;
            Cmd.Parameters.Add("@TariffAmtTo1", SqlDbType.Decimal).Value = Tax.TariffAmtTo1;
            Cmd.Parameters.Add("@Taxper1", SqlDbType.Decimal).Value = Tax.Taxper1;
            Cmd.Parameters.Add("@TariffAmtFrom2", SqlDbType.Decimal).Value = Tax.TariffAmtFrom2;
            Cmd.Parameters.Add("@TariffAmtTo2", SqlDbType.Decimal).Value = Tax.TariffAmtTo2;
            Cmd.Parameters.Add("@Taxper2", SqlDbType.Decimal).Value = Tax.Taxper2;
            Cmd.Parameters.Add("@TariffAmtFrom3", SqlDbType.Decimal).Value = Tax.TariffAmtFrom3;
            Cmd.Parameters.Add("@TariffAmtTo3", SqlDbType.Decimal).Value = Tax.TariffAmtTo3;
            Cmd.Parameters.Add("@Taxper3", SqlDbType.Decimal).Value = Tax.Taxper3;
            Cmd.Parameters.Add("@State", SqlDbType.NVarChar).Value = Tax.State;
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Tax.StateId;
            Cmd.Parameters.Add("@Date", SqlDbType.NVarChar).Value = Tax.Date;
            Cmd.Parameters.Add("@VATNo", SqlDbType.NVarChar).Value = Tax.VATNo;
            Cmd.Parameters.Add("@LuxuryNo", SqlDbType.NVarChar).Value = Tax.LuxuryNo;
            Cmd.Parameters.Add("@ServiceNo", SqlDbType.NVarChar).Value = Tax.ServiceNo;
            Cmd.Parameters.Add("@RestaurantST", SqlDbType.NVarChar).Value = Tax.RestaurantST;
            Cmd.Parameters.Add("@BusinessSupportST", SqlDbType.NVarChar).Value = Tax.BusinessSupportST;
            Cmd.Parameters.Add("@RackTariff", SqlDbType.Bit).Value = Tax.RackTariff;
            Cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = User.Id;
            Cmd.Parameters.Add("@TINNumber", SqlDbType.NVarChar).Value = Tax.TINNumber;
            Cmd.Parameters.Add("@CINNumber", SqlDbType.NVarChar).Value = Tax.CINNumber;
            DataSet Value = new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
            
            return Value;
        }
        public DataSet Search(string[] data, User User)
        {
            UserData = "  UserId:" + User.Id + ",UsreName:" + User.LoginUserName + ",ScreenName:'" + User.ScreenName +
                   "',SctId:" + User.SctId + ",Service:  UserRolesDao  Search" + ",Nil:'"; 

            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Help(string[] data, User User)
        {
            UserData = "  UserId:" + User.Id + ",UsreName:" + User.LoginUserName + ",ScreenName:'" + User.ScreenName +
                    "',SctId:" + User.SctId + ",Service:  UserRolesDao Help" + ",ProcName:'" + StoredProcedures.TaxMaster_Help; 
            
            Cmd = new SqlCommand();
            Cmd.CommandText = StoredProcedures.TaxMaster_Help;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
            Cmd.Parameters.Add("@Str1", SqlDbType.NVarChar).Value = data[2].ToString();
            Cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Convert.ToInt32(data[3].ToString());
            Cmd.Parameters.Add("@StateId", SqlDbType.Int).Value = Convert.ToInt32(data[4].ToString());
            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

        public DataSet Delete(string[] data, User User)
        {
            UserData = "  UserId:" + User.Id + ",UsreName:" + User.LoginUserName + ",ScreenName:'" + User.ScreenName +
                   "',SctId:" + User.SctId + ",Service:  UserRolesDao  Delete" + ",Nil:'";

            return new WrbErpConnection().ExecuteDataSet(Cmd, UserData);
        }

    }
}
