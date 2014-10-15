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
    public class PropertyAgreementsRoomChargesDAO
    {
        String UserData;
        public DataSet Save(string Hdrval, User user, int AgreementId)
        {
            DataSet ds = new DataSet();
            DataTable dTable = new DataTable("DBERRORTBL");
            dTable.Columns.Add("Exception");
            SqlCommand command = new SqlCommand();
            PropertyAgreementsRoomCharges PrptyAgrementRoomCharge = new PropertyAgreementsRoomCharges();
            XmlDocument document = new XmlDocument();
            document.LoadXml(Hdrval);
            int n;
            n = (document).SelectNodes("//GridXml").Count;
            for (int i = 0; i < n; i++)
            {
                PrptyAgrementRoomCharge.AgreementId = AgreementId;
                PrptyAgrementRoomCharge.Facility = document.SelectNodes("//GridXml")[i].Attributes["Facility"].Value;
                if (document.SelectNodes("//GridXml")[i].Attributes["RackSingle"].Value == "")
                {
                    PrptyAgrementRoomCharge.RackSingle = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.RackSingle = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["RackSingle"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["RackDouble"].Value == "")
                {
                    PrptyAgrementRoomCharge.RackDouble = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.RackDouble = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["RackDouble"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["RackTriple"].Value == "")
                {
                    PrptyAgrementRoomCharge.RackTriple = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.RackTriple = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["RackTriple"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["Single"].Value == "")
                {
                    PrptyAgrementRoomCharge.Single = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.Single = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Single"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["RDouble"].Value == "")
                {
                    PrptyAgrementRoomCharge.Double = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.Double = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["RDouble"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["Triple"].Value == "")
                {
                    PrptyAgrementRoomCharge.Triple = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.Triple = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Triple"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["Description"].Value == "")
                {
                    PrptyAgrementRoomCharge.Description = "";
                }
                else
                {
                    PrptyAgrementRoomCharge.Description = document.SelectNodes("//GridXml")[i].Attributes["Description"].Value;
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["Tax"].Value == "")
                {
                    PrptyAgrementRoomCharge.Tax = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.Tax = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Tax"].Value);
                }               
                PrptyAgrementRoomCharge.Inclusive = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["Inclusive"].Value);
               
                PrptyAgrementRoomCharge.RoomType = document.SelectNodes("//GridXml")[i].Attributes["RoomType"].Value;
                if (document.SelectNodes("//GridXml")[i].Attributes["Amount"].Value == "")
                {
                    PrptyAgrementRoomCharge.Amount = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.Amount = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["Amount"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["LTAgreed"].Value == "")
                {
                    PrptyAgrementRoomCharge.LTAgreed = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.LTAgreed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["LTAgreed"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["STAgreed"].Value == "")
                {
                    PrptyAgrementRoomCharge.STAgreed = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.STAgreed = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["STAgreed"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["LTRack"].Value == "")
                {
                    PrptyAgrementRoomCharge.LTRack = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.LTRack = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["LTRack"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["STRack"].Value == "")
                {
                    PrptyAgrementRoomCharge.STRack = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.STRack = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["STRack"].Value);
                }
                if (document.SelectNodes("//GridXml")[i].Attributes["SC"].Value == "")
                {
                    PrptyAgrementRoomCharge.SC = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.SC = Convert.ToDecimal(document.SelectNodes("//GridXml")[i].Attributes["SC"].Value);
                }
                PrptyAgrementRoomCharge.Visible = Convert.ToBoolean(document.SelectNodes("//GridXml")[i].Attributes["Visible"].Value);
                if (document.SelectNodes("//GridXml")[i].Attributes["Id"].Value == "")
                {
                    PrptyAgrementRoomCharge.Id = 0;
                }
                else
                {
                    PrptyAgrementRoomCharge.Id = Convert.ToInt32(document.SelectNodes("//GridXml")[i].Attributes["Id"].Value);
                }
                command = new SqlCommand();
                if (PrptyAgrementRoomCharge.Id != 0)
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PropertyAgreementsRoomChargesDAO Update" + ", ProcName:'" + StoredProcedures.PropertyAgreementRoomCharges_Update; 

                     command.CommandText = StoredProcedures.PropertyAgreementRoomCharges_Update;
                    command.Parameters.Add("@Id", SqlDbType.BigInt).Value = PrptyAgrementRoomCharge.Id;
                }
                else
                {
                    UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                        "', SctId:" + user.SctId + ", Service:PropertyAgreementsRoomChargesDAO Insert" + ", ProcName:'" + StoredProcedures.PropertyAgreementRoomCharges_Insert; 

                    command.CommandText = StoredProcedures.PropertyAgreementRoomCharges_Insert;
                }
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@AgreementId", SqlDbType.BigInt).Value = PrptyAgrementRoomCharge.AgreementId;
                command.Parameters.Add("@RackSingle", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.RackSingle;
                command.Parameters.Add("@RackDouble", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.RackDouble;
                command.Parameters.Add("@RackTriple", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.RackTriple;
                command.Parameters.Add("@RSingle", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.Single;
                command.Parameters.Add("@RDouble", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.Double;
                command.Parameters.Add("@RTriple", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.Triple;
                command.Parameters.Add("@Description", SqlDbType.NVarChar).Value = PrptyAgrementRoomCharge.Description;
                command.Parameters.Add("@Facility", SqlDbType.NVarChar).Value = PrptyAgrementRoomCharge.Facility;
                command.Parameters.Add("@Tax", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.Tax;
                command.Parameters.Add("@Inclusive", SqlDbType.Bit).Value = PrptyAgrementRoomCharge.Inclusive;
                command.Parameters.Add("@Amount", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.Amount;
                command.Parameters.Add("@RoomType", SqlDbType.NVarChar).Value = PrptyAgrementRoomCharge.RoomType;
                command.Parameters.Add("@LTAgreed", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.LTAgreed;
                command.Parameters.Add("@STAgreed", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.STAgreed;
                command.Parameters.Add("@LTRack", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.LTRack;
                command.Parameters.Add("@STRack", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.STRack;
                command.Parameters.Add("@SC", SqlDbType.Decimal).Value = PrptyAgrementRoomCharge.SC;
                command.Parameters.Add("@Visible", SqlDbType.Bit).Value = PrptyAgrementRoomCharge.Visible;
                command.Parameters.Add("@CreatedBy", SqlDbType.BigInt).Value = user.Id;

                ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
            }
            if (n == 0)
            {
                ds.Tables.Add(dTable);
            }
            return ds;
        }
    }
}
