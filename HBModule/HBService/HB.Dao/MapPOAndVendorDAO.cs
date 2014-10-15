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
using System.Text.RegularExpressions;
using Excel = Microsoft.Office.Interop.Excel;
using System.Drawing;
using System.IO;
namespace HB.Dao
{
   public class MapPOAndVendorDAO
    {
       String UserData;
       public DataSet Save(string [] PropertyAssignedGuest, User user, int BookingId, string Remarks, string SendMail)
       {
          
          
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           SqlCommand command = new SqlCommand();

           XmlDocument document = new XmlDocument();
           document.LoadXml(PropertyAssignedGuest[1].ToString());

           //Header Insert
           MapPOAndVendorEntity MapPOVEN = new MapPOAndVendorEntity();
           MapPOVEN.PropertyId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["PropertyId"].Value);
           MapPOVEN.InvoiceAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["InvoiceAmount"].Value);
           MapPOVEN.InvoiceDate = document.SelectSingleNode("HdrXml").Attributes["InvoiceDate"].Value;
           MapPOVEN.InvoiceNo = document.SelectSingleNode("HdrXml").Attributes["InvoiceNo"].Value;
           MapPOVEN.Property = document.SelectSingleNode("HdrXml").Attributes["Property"].Value;
           MapPOVEN.TotalPOAmount = Convert.ToDecimal(document.SelectSingleNode("HdrXml").Attributes["TotalPOAmount"].Value);
           MapPOVEN.HdrId = Convert.ToInt32(document.SelectSingleNode("HdrXml").Attributes["Id"].Value);

          
            UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
            "', SctId:" + user.SctId + ", Service:Map POAndVendor Payment Hdr DAO Insert" + ",ProcName:'" +
            StoredProcedures.MapPOAndVendorPaymentHdr_Insert;

           command.CommandText = StoredProcedures.MapPOAndVendorPaymentHdr_Insert;          
           command.CommandType = CommandType.StoredProcedure;
           command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = MapPOVEN.PropertyId;
           command.Parameters.Add("@InvoiceAmount", SqlDbType.Decimal).Value = MapPOVEN.InvoiceAmount;
           command.Parameters.Add("@InvoiceDate", SqlDbType.NVarChar).Value = MapPOVEN.InvoiceDate;
           command.Parameters.Add("@InvoiceNo", SqlDbType.NVarChar).Value = MapPOVEN.InvoiceNo;
           command.Parameters.Add("@Property", SqlDbType.NVarChar).Value = MapPOVEN.Property;
           command.Parameters.Add("@TotalPOAmount", SqlDbType.Decimal).Value = MapPOVEN.TotalPOAmount; 
           command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
           ds = new WrbErpConnection().ExecuteDataSet(command, UserData);

           //Details Insert
           var Id = Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString());

           document = new XmlDocument();
           document.LoadXml(PropertyAssignedGuest[2].ToString());
           int n;
           n = (document).SelectNodes("//DtlsXml").Count;
           for (int i = 0; i < n; i++)
           {
               MapPOVEN = new MapPOAndVendorEntity();
               MapPOVEN.CheckOutId = Convert.ToInt32(document.SelectNodes("//DtlsXml")[i].Attributes["CheckOutId"].Value);
               MapPOVEN.BookingId = Convert.ToInt32(document.SelectNodes("//DtlsXml")[i].Attributes["BookingId"].Value);
               MapPOVEN.PONo = document.SelectNodes("//DtlsXml")[i].Attributes["PONo"].Value;
               MapPOVEN.BookingCode = document.SelectNodes("//DtlsXml")[i].Attributes["BookingCode"].Value;
               MapPOVEN.BillAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml")[i].Attributes["BillAmount"].Value);
               MapPOVEN.POAmount = Convert.ToDecimal(document.SelectNodes("//DtlsXml")[i].Attributes["POAmount"].Value);
               MapPOVEN.Adjustment = Convert.ToDecimal(document.SelectNodes("//DtlsXml")[i].Attributes["Adjustment"].Value);
               MapPOVEN.GuestName =document.SelectNodes("//DtlsXml")[i].Attributes["GuestName"].Value;
               MapPOVEN.StayDuration = document.SelectNodes("//DtlsXml")[i].Attributes["StayDuration"].Value;
               //MapPOVEN.d = Convert.ToInt32(document.SelectNodes("//DtlsXml")[i].Attributes["Id"].Value);


               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
               "', SctId:" + user.SctId + ", Service:Map POAndVendor Payment Dtls DAO Insert" + ",ProcName:'" +
               StoredProcedures.MapPOAndVendorPaymentDtls_Insert;

               command = new SqlCommand();
               command.CommandText = StoredProcedures.MapPOAndVendorPaymentDtls_Insert;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@MapPOAndVendorPaymentHdrId", SqlDbType.BigInt).Value = Id;
               command.Parameters.Add("@CheckOutId", SqlDbType.BigInt).Value = MapPOVEN.CheckOutId;
               command.Parameters.Add("@BookingId", SqlDbType.BigInt ).Value = MapPOVEN.BookingId;
               command.Parameters.Add("@PONo", SqlDbType.NVarChar).Value = MapPOVEN.PONo;
               command.Parameters.Add("@BookingCode", SqlDbType.NVarChar).Value = MapPOVEN.BookingCode;
               command.Parameters.Add("@BillAmount", SqlDbType.Decimal).Value = MapPOVEN.BillAmount;              
               command.Parameters.Add("@POAmount", SqlDbType.Decimal).Value = MapPOVEN.POAmount;
               command.Parameters.Add("@Adjustment", SqlDbType.Decimal).Value = MapPOVEN.Adjustment;
               command.Parameters.Add("@GuestName", SqlDbType.NVarChar).Value = MapPOVEN.GuestName;
               command.Parameters.Add("@StayDuration", SqlDbType.NVarChar).Value = MapPOVEN.StayDuration;
               command.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = user.Id;
              
               ds = new WrbErpConnection().ExecuteDataSet(command, UserData);
              
           }
          
           return ds;
       }
       public DataSet Help(string[] data, User user)
       {
           DataSet ds = new DataSet();
           DataTable ErrdT = new DataTable("DBERRORTBL");
           ErrdT.Columns.Add("Exception");

           DataTable ErrdT1 = new DataTable("TabelsNew");
           ErrdT1.Columns.Add("Exception");

           if (data[1].ToString() == "Export")
           {
               

               try
               {

                   Excel.Application xlApp = new Excel.Application();

                   Excel.Workbook xlWorkBook = xlApp.Workbooks.Add(System.Reflection.Missing.Value);
                   Excel.Worksheet workSheet = (Excel.Worksheet)xlWorkBook.Worksheets.get_Item(1);

                 
                    //xlApp = new Excel.Application();
                    //xlWorkBook = xlApp.Workbooks.Add(1);

                    //workSheet = (Excel.Worksheet)xlWorkBook.ActiveSheet;

                   XmlDocument document = new XmlDocument();
                   document.LoadXml(data[3].ToString());
                   workSheet.Cells[1, 7] = "External Property Invoice Report";
                   workSheet.Cells[2, 6] = "Total Tariff Amount";
                   workSheet.Cells[2, 7] = "Difference Amount";
                   workSheet.Cells[2, 8] = "Difference Amount in  %";

                   workSheet.Cells[3, 6] = document.SelectSingleNode("DtlsXml1").Attributes["MarkUpTotalTariff"].Value;
                   workSheet.Cells[3, 7] = document.SelectSingleNode("DtlsXml1").Attributes["DifferanceAmount"].Value;
                   workSheet.Cells[3, 8] = document.SelectSingleNode("DtlsXml1").Attributes["PER"].Value;

                   document = new XmlDocument();
                   document.LoadXml(data[4].ToString());

                   workSheet.Cells[5, 1] = document.SelectSingleNode("HdrXml").Attributes["BookingDate"].Value;
                   workSheet.Cells[5, 2] = document.SelectSingleNode("HdrXml").Attributes["BillNumber"].Value;
                   workSheet.Cells[5, 3] = document.SelectSingleNode("HdrXml").Attributes["PropertyName"].Value;
                   workSheet.Cells[5, 4] = document.SelectSingleNode("HdrXml").Attributes["CompanyName"].Value;
                   workSheet.Cells[5, 5] = document.SelectSingleNode("HdrXml").Attributes["GuestName"].Value;
                   workSheet.Cells[5, 6] = document.SelectSingleNode("HdrXml").Attributes["BillStartDate"].Value;
                   workSheet.Cells[5, 7] = document.SelectSingleNode("HdrXml").Attributes["BillEndDate"].Value;
                   workSheet.Cells[5, 8] = document.SelectSingleNode("HdrXml").Attributes["NoOFDays"].Value;
                   workSheet.Cells[5, 9] = document.SelectSingleNode("HdrXml").Attributes["Tariff"].Value;
                   workSheet.Cells[5, 10] = document.SelectSingleNode("HdrXml").Attributes["MarkUpTotalTariff"].Value;
                   workSheet.Cells[5, 11] = document.SelectSingleNode("HdrXml").Attributes["ServiceTax"].Value;
                   workSheet.Cells[5, 12] = document.SelectSingleNode("HdrXml").Attributes["VendorNoOFDays"].Value;
                   workSheet.Cells[5, 13] = document.SelectSingleNode("HdrXml").Attributes["TariffPerday"].Value;
                   workSheet.Cells[5, 14] = document.SelectSingleNode("HdrXml").Attributes["VendorInvoiceAmount"].Value;
                   workSheet.Cells[5, 15] = document.SelectSingleNode("HdrXml").Attributes["DifferenceAmount"].Value;

                   document = new XmlDocument();
                   document.LoadXml(data[5].ToString());
                   int c;
                   c = (document).SelectNodes("//DtlsXml").Count;
                   // column

                  
                   // // to do: format datetime values before printing

                   for (int j = 0; j < c; j++)
                   {
                       workSheet.Cells[j + 6, 1] = document.SelectNodes("//DtlsXml")[j].Attributes["BookingDate"].Value;
                       workSheet.Cells[j + 6, 2] = document.SelectNodes("//DtlsXml")[j].Attributes["BillNumber"].Value;
                       workSheet.Cells[j + 6, 3] = document.SelectNodes("//DtlsXml")[j].Attributes["PropertyName"].Value;
                       workSheet.Cells[j + 6, 4] = document.SelectNodes("//DtlsXml")[j].Attributes["CompanyName"].Value;
                       workSheet.Cells[j + 6, 5] = document.SelectNodes("//DtlsXml")[j].Attributes["GuestName"].Value;
                       workSheet.Cells[j + 6, 6] = document.SelectNodes("//DtlsXml")[j].Attributes["BillStartDate"].Value;
                       workSheet.Cells[j + 6, 7] = document.SelectNodes("//DtlsXml")[j].Attributes["BillEndDate"].Value;
                       workSheet.Cells[j + 6, 8] = document.SelectNodes("//DtlsXml")[j].Attributes["NoOFDays"].Value;
                       workSheet.Cells[j + 6, 9] = document.SelectNodes("//DtlsXml")[j].Attributes["Tariff"].Value;
                       workSheet.Cells[j + 6, 10] = document.SelectNodes("//DtlsXml")[j].Attributes["MarkUpTotalTariff"].Value;
                       workSheet.Cells[j + 6, 11] = document.SelectNodes("//DtlsXml")[j].Attributes["ServiceTax"].Value;
                       workSheet.Cells[j + 6, 12] = document.SelectNodes("//DtlsXml")[j].Attributes["NoOFDays"].Value;
                       workSheet.Cells[j + 6, 13] = document.SelectNodes("//DtlsXml")[j].Attributes["VendorTariff"].Value;
                       workSheet.Cells[j + 6, 14] = document.SelectNodes("//DtlsXml")[j].Attributes["VendorTotal"].Value;
                       workSheet.Cells[j + 6, 15] = document.SelectNodes("//DtlsXml")[j].Attributes["DifferanceAmount"].Value;


                   }


                   workSheet.get_Range("A1", "O2").Font.Bold = true;

                   workSheet.get_Range("A1", "O2").Font.Size = 16;

                   workSheet.get_Range("A1", "O2").Font.Name = "Times New Roman";

                   workSheet.get_Range("A5", "O5").Font.Bold = true;

                   workSheet.get_Range("A5", "O5").Font.Size = 16;

                   workSheet.get_Range("A5", "O5").Font.Name = "Times New Roman";

                   workSheet.get_Range("A1", "O1000000").Columns.AutoFit();

                 
                   
                        
                        // check fielpath
                   var ExcelFilePath = "C:/Users/lenovo/Desktop";

                   if (ExcelFilePath != null && ExcelFilePath != "")
                   {

                       try
                       {
                             string sLogFormat;
                             string sErrorTime;

                           sLogFormat = DateTime.Now.ToShortDateString().ToString() + " " + DateTime.Now.ToLongTimeString().ToString() + " ==> ";
                           string sYear = DateTime.Now.Year.ToString();
                           string sMonth = DateTime.Now.Month.ToString();
                           string sDay = DateTime.Now.Day.ToString();
                           string sTime = DateTime.Now.Minute.ToString();
                           sErrorTime = sYear + sMonth + sDay + sTime;


                           
                            //var dia = new System.Windows.Forms.SaveFileDialog();
                            //dia.InitialDirectory = Environment.GetFolderPath(Environment.SpecialFolder.CommonDocuments);
                            //dia.Filter = "Excel Worksheets (*.xlsx)|*.xlsx|xls file (*.xls)|*.xls|All files (*.*)|*.*";
                            //dia.FileName = dia.InitialDirectory+"\\ExternalInvoice" + sErrorTime + ".xlsx";
                            
                            //xlWorkBook.SaveAs(file);
    
                           //string fileName = "ExternalInvoice"+sErrorTime+".xlsx";
                           //string path = @"C:\" + fileName;

                           xlApp.Visible = true;
                           ////using (var file = File.Create(dia.FileName))
                          // xlWorkBook.SaveAs(path, Excel.XlFileFormat.xlWorkbookNormal, , , , ,
                           ////Excel.XlSaveAsAccessMode.xlExclusive, misValue, misValue, misValue, misValue, misValue);
                           //xlWorkBook.Close(true, misValue, misValue);                           
                           //xlApp.Quit();                         


                           releaseObject(workSheet);
                           releaseObject(xlWorkBook);
                           releaseObject(xlApp);
                           xlApp.Quit();
                           ErrdT1.Rows.Add("Excel file created , you can find the file   ");
                          // MessageBox.Show("Excel file saved!");
                           ds.Tables.Add(ErrdT1);
                       }

                       catch (Exception ex)
                       {


                           CreateLogFiles Err = new CreateLogFiles();
                           Err.ErrorLog(ex.Message);
                           //Err.ErrorLog(ConfigurationManager.ConnectionStrings["Log"].ToString(), Ex.Message, UserData);
                           ErrdT.Rows.Add("ExportToExcel: Excel file could not be saved! Check filepath.\n"

                           + ex.Message);

                       }

                   }                 

               }

               catch (Exception ex)
               {
                   CreateLogFiles Err = new CreateLogFiles();
                   Err.ErrorLog(ex.Message);
                   //Err.ErrorLog(ConfigurationManager.ConnectionStrings["Log"].ToString(), Ex.Message, UserData);
                   ErrdT.Rows.Add("ExportToExcel: \n" + ex.Message);
                  
               }
               ds.Tables.Add(ErrdT); ErrdT.Dispose(); ErrdT = null;

           }
           else
           {

               UserData = " UserId:" + user.Id + ", UsreName:" + user.LoginUserName + ", ScreenName:'" + user.ScreenName +
                 "', SctId:" + user.SctId + ", Service : MapPOandVendorDao : Help, " + ", ProcName:'" + StoredProcedures.MapPOandVendor_Help;
               SqlCommand command = new SqlCommand();
               command.CommandText = StoredProcedures.MapPOandVendor_Help;
               command.CommandType = CommandType.StoredProcedure;
               command.Parameters.Add("@Action", SqlDbType.NVarChar).Value = data[1].ToString();
               command.Parameters.Add("@PropertyId", SqlDbType.BigInt).Value = Convert.ToInt32(data[2].ToString());
               command.Parameters.Add("@FromDate", SqlDbType.NVarChar).Value = data[3].ToString();
               command.Parameters.Add("@ToDate", SqlDbType.NVarChar).Value = data[4].ToString();
               command.Parameters.Add("@Param1", SqlDbType.NVarChar).Value = data[5].ToString();
               command.Parameters.Add("@Param2", SqlDbType.BigInt).Value = Convert.ToInt32(data[6].ToString());
               command.Parameters.Add("@UserId", SqlDbType.BigInt).Value = Convert.ToInt32(user.Id);
               ds= new WrbErpConnection().ExecuteDataSet(command, UserData);
           }
           return ds;


       }
       private void releaseObject(object obj)
       {
           try
           {
               System.Runtime.InteropServices.Marshal.ReleaseComObject(obj);
               obj = null;
           }
           catch (Exception ex)
           {
               obj = null;
               
           }
           finally
           {
               GC.Collect();
           }
       }

    }
}
