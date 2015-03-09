using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.Mvc;
using test1.DAO;
using test1.Models;
using test1.Utils;
using Excel = Microsoft.Office.Interop.Excel;
using System.Drawing;
using test1.ActionResults;
using System.Configuration;
using WebMatrix.WebData;

namespace test1.Controllers
{
    public class GHReportController : Controller
    {
        //
        // GET: /GHReport/
        public ActionResult Index()
        {
            string clintgId = "";
            using (HBEntities db = new HBEntities())
            {
                var CliendId = (from c in db.ClientAndUserId(WebSecurity.CurrentUserId, "TRDESK")
                                select c.ClientId).FirstOrDefault();
                if (CliendId != null)
                clintgId = Convert.ToString(CliendId);
                if (CliendId == null)
                {
                    var CliendId1 = (from c in db.ClientAndUserId(WebSecurity.CurrentUserId, "ENDUSR")
                                     select c.ClientId).FirstOrDefault();

                    clintgId = Convert.ToString(CliendId1);
                }

                string[] Hdrval = new string[5];
                Hdrval[0] = "SP_GHReport_Help"; Hdrval[1] = "Property"; Hdrval[2] = ""; Hdrval[3] = ""; Hdrval[4] = clintgId;
                DataSet ds = new GHDataDao().GHData(Hdrval);
                ViewBag.Property = ds.Tables[0].ToList<GHModel>();
                return View();
            }
        }

        [HttpGet]
        public JsonResult GHData(string StartDate, string EndDate, string PropertyId)
        {
            string[] Hdrval = new string[5];
            Hdrval[0] = "SP_GHReport_Help"; Hdrval[1] = "OccupancyChart"; Hdrval[2] = StartDate; Hdrval[3] = EndDate; Hdrval[4] = PropertyId;

            DataSet ds = new GHDataDao().GHData(Hdrval);
            if (ds.Tables[0].Rows[0][0].ToString() == "Room NO")
            {
                var Property = ds.Tables[0].ToList<GHModel>();

                return Json(Property, JsonRequestBehavior.AllowGet);
            }
            var Property1 = "";
            return Json(Property1, JsonRequestBehavior.AllowGet);

        }
        [HttpGet]
        public JsonResult GHExport(string StartDate, string EndDate, string PropertyId)
        {

            string[] Hdrval = new string[5];
            Hdrval[0] = "SP_GHReport_Help"; Hdrval[1] = "OccupancyChart"; Hdrval[2] = StartDate; Hdrval[3] = EndDate; Hdrval[4] = PropertyId;

            DataSet ds = new GHDataDao().GHData(Hdrval);
            string sLogFormat;
            string sErrorTime;

            sLogFormat = DateTime.Now.ToShortDateString().ToString() + " " + DateTime.Now.ToLongTimeString().ToString() + " ==> ";
            string sYear = DateTime.Now.Year.ToString();
            string sMonth = DateTime.Now.Month.ToString();
            string sDay = DateTime.Now.Day.ToString();
            string sTime = DateTime.Now.Minute.ToString();
            string ssTime = DateTime.Now.Second.ToString();
            sErrorTime = sYear + sMonth + sDay + sTime + ssTime;
            var ExcelFilePath = ConfigurationManager.ConnectionStrings["Excel"].ToString();
            string fileName = ExcelFilePath + ds.Tables[1].Rows[0][0].ToString() + sErrorTime + ".xls";
            string fileName1 = ds.Tables[1].Rows[0][0].ToString() + sErrorTime + ".xls";

            if (ds.Tables[0].Rows[0][0].ToString() == "Room NO")
            {
                var Property = ds.Tables[0].ToList<GHModel>();

                try
                {


                    Excel.Application xlApp = new Excel.Application();
                    Excel.Workbook xlWorkBook = xlApp.Workbooks.Add(System.Reflection.Missing.Value);
                    Excel.Worksheet workSheet = (Excel.Worksheet)xlWorkBook.Worksheets.get_Item(1);

                    int c;
                    c = ds.Tables[0].Rows.Count;
                    // column


                    // // to do: format datetime values before printing
                    int Row = 2;
                    int RowX = 3;
                    bool RoomFlag = true;
                    bool BedFlag = true;
                    bool DataFlag = true;
                    bool BedCountFlag = true;
                    bool PerFlag = true;
                    bool NoFlag = true;
                    bool EmployeeFlag = true;
                    bool BedOccupancyFlag = true;
                    bool RoomOccupancyFlag = true;

                    DateTime FDate = Convert.ToDateTime(ds.Tables[1].Rows[0][1].ToString());
                    DateTime TDate = Convert.ToDateTime(ds.Tables[1].Rows[0][2].ToString());
                    string Fdate = FDate.ToString("dd/MM/yyyy");
                    string Tdate = TDate.ToString("dd/MM/yyyy");

                    workSheet.Cells[1, 3] = ds.Tables[1].Rows[0][0].ToString() + " Occupancy Report -" + Fdate + " to " + Tdate;
                    workSheet.Range[workSheet.Cells[1, 3], workSheet.Cells[1, 6]].Merge();
                    workSheet.Range[workSheet.Cells[1, 3], workSheet.Cells[1, 6]].Cells.HorizontalAlignment =
                    Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;

                    for (int j = 0; j < c; j++)
                    {
                        if (ds.Tables[0].Rows[j][0].ToString() == "Room NO")
                        {
                            if (RoomFlag == true)
                            {
                                if (ds.Tables[0].Rows[j][7].ToString() == "2")
                                {
                                    workSheet.Cells[2, Row + 1] = "Room - " + ds.Tables[0].Rows[j][4].ToString();
                                    workSheet.Range[workSheet.Cells[2, Row + 1], workSheet.Cells[2, Row + 2]].Merge();
                                    workSheet.Range[workSheet.Cells[2, Row + 1], workSheet.Cells[2, Row + 2]].Cells.HorizontalAlignment =
                                    Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;

                                    //  Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#4492a6");
                                    // workSheet.Range[workSheet.Cells[1, Row + 1], workSheet.Cells[1, Row + 2]].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                    Row += 2;
                                    RoomFlag = false;
                                }
                                else
                                {
                                    workSheet.Cells[2, Row + 1] = "Room - " + ds.Tables[0].Rows[j][4].ToString();
                                    Row += 1;
                                }

                            }
                            else
                            {
                                RoomFlag = true;
                            }

                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Bed NO")
                        {
                            if (BedFlag == true)
                            {
                                Row = 2;
                                BedFlag = false;
                                workSheet.Cells[3, 1] = "Stay for the night of";
                                workSheet.Cells[3, 2] = "Day of the week";
                            }
                            workSheet.Cells[3, Row + 1] = ds.Tables[0].Rows[j][5].ToString();
                            Row += 1;
                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Data")
                        {
                            if (DataFlag == true)
                            {
                                workSheet.Cells[3, Row + 1] = "Total Occupancy";
                                DataFlag = false;
                            }
                            if (ds.Tables[0].Rows[j][4].ToString() == "Date")
                            {
                                RowX += 1;
                                Row = 0;
                                DateTime oDate = Convert.ToDateTime(ds.Tables[0].Rows[j][1].ToString());

                                string year = oDate.Year.ToString();

                                // Month gets 1 (January). 
                                string month = oDate.Month.ToString();

                                // Day gets 13. 
                                string day = oDate.Day.ToString();

                                string days = oDate.ToString("dddd");

                                string date = oDate.ToString("dd/MM/yyyy");
                                workSheet.Cells[RowX, Row + 1] = days;

                                workSheet.Cells[RowX, Row + 2] = date;

                                Row += 2;
                            }
                            else
                            {
                                string value = ds.Tables[0].Rows[j][6].ToString();
                                workSheet.Cells[RowX, Row + 1] = value;

                                Row += 1;
                            }


                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Bed Count")
                        {
                            if (BedCountFlag == true)
                            {
                                Row = 2;
                                RowX += 1;
                                BedCountFlag = false;
                                workSheet.Cells[RowX, 2] = "Actual occupancy";
                            }
                            workSheet.Cells[RowX, Row + 1] = ds.Tables[0].Rows[j][6].ToString();

                            Row += 1;
                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "No Of Days")
                        {
                            if (NoFlag == true)
                            {
                                Row = 2;
                                RowX += 1;
                                NoFlag = false;
                                workSheet.Cells[RowX, 2] = "No. of days";
                            }
                            workSheet.Cells[RowX, Row + 1] = ds.Tables[0].Rows[j][6].ToString();

                            Row += 1;
                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Percentage")
                        {
                            if (PerFlag == true)
                            {
                                Row = 2;
                                RowX += 1;
                                PerFlag = false;
                                workSheet.Cells[RowX, 2] = "% occupancy";
                            }
                            workSheet.Cells[RowX, Row + 1] = ds.Tables[0].Rows[j][6].ToString();

                            Row += 1;
                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Bed Occupancy")
                        {
                            if (BedOccupancyFlag == true)
                            {
                                Row += 1;
                                RowX = 3;
                                BedOccupancyFlag = false;
                                workSheet.Cells[2, Row] = "Total Bed Occupancy";
                                workSheet.Range[workSheet.Cells[2, Row], workSheet.Cells[2, Row + 2]].Merge();
                                //.get_Range(workSheet.Cells[2, 1], workSheet.Cells[2, 3]).HorizontalAlignment = Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;

                                workSheet.Range[workSheet.Cells[2, Row], workSheet.Cells[2, Row + 2]].Cells.HorizontalAlignment =
                                Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;
                                workSheet.Cells[3, Row + 1] = "Beds Occupied";
                                workSheet.Cells[3, Row + 2] = "Beds Vacant";
                                workSheet.Cells[3, Row + 3] = "Occupancy %";

                            }
                            workSheet.Cells[RowX + 1, Row + 1] = ds.Tables[0].Rows[j][2].ToString();

                            workSheet.Cells[RowX + 1, Row + 2] = ds.Tables[0].Rows[j][3].ToString();

                            workSheet.Cells[RowX + 1, Row + 3] = ds.Tables[0].Rows[j][4].ToString();

                            //Row += 1;
                            RowX += 1;
                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Room Occupancy")
                        {
                            if (RoomOccupancyFlag == true)
                            {
                                Row += 3;
                                RowX = 3;
                                RoomOccupancyFlag = false;
                                workSheet.Cells[2, Row] = "Total Room Occupancy";
                                workSheet.Range[workSheet.Cells[2, Row], workSheet.Cells[2, Row + 2]].Merge();
                                //.get_Range(workSheet.Cells[2, 1], workSheet.Cells[2, 3]).HorizontalAlignment = Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;

                                workSheet.Range[workSheet.Cells[2, Row], workSheet.Cells[2, Row + 2]].Cells.HorizontalAlignment =
                                Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;
                                workSheet.Cells[3, Row + 1] = "Rooms Occupied";
                                workSheet.Cells[3, Row + 2] = "Rooms Vacant";
                                workSheet.Cells[3, Row + 3] = "Occupancy %";

                            }
                            workSheet.Cells[RowX + 1, Row + 1] = ds.Tables[0].Rows[j][2].ToString();

                            workSheet.Cells[RowX + 1, Row + 2] = ds.Tables[0].Rows[j][3].ToString();

                            workSheet.Cells[RowX + 1, Row + 3] = ds.Tables[0].Rows[j][4].ToString();

                            //Row += 1;
                            RowX += 1;
                        }
                        else if (ds.Tables[0].Rows[j][0].ToString() == "Employee")
                        {
                            if (EmployeeFlag == true)
                            {
                                Row += 5;
                                RowX = 3;
                                EmployeeFlag = false;
                                workSheet.Cells[2, Row] = "Master Guest Details";
                                workSheet.Range[workSheet.Cells[2, Row], workSheet.Cells[2, Row + 6]].Merge();
                                //.get_Range(workSheet.Cells[2, 1], workSheet.Cells[2, 3]).HorizontalAlignment = Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;

                                workSheet.Range[workSheet.Cells[2, Row], workSheet.Cells[2, Row + 6]].Cells.HorizontalAlignment =
                                Microsoft.Office.Interop.Excel.XlHAlign.xlHAlignCenter;
                                workSheet.Cells[3, Row + 1] = "Guest Name";
                                workSheet.Cells[3, Row + 2] = "Guest Circle Name";
                                workSheet.Cells[3, Row + 3] = "Band";
                                workSheet.Cells[3, Row + 4] = "Consolidated Room Nights";
                            }
                            workSheet.Cells[RowX + 1, Row + 1] = ds.Tables[0].Rows[j][6].ToString();

                            workSheet.Cells[RowX + 1, Row + 4] = ds.Tables[0].Rows[j][5].ToString();

                            //Row += 1;
                            RowX += 1;
                        }

                    }


                    //workSheet.get_Range("A1", "O2").Font.Bold = true;

                    //workSheet.get_Range("A1", "O2").Font.Size = 16;

                    workSheet.get_Range("A1", "BB3").Font.Name = "Times New Roman";

                    workSheet.get_Range("A1", "BB3").Font.Bold = true;

                    workSheet.get_Range("A1", "BB3").Font.Size = 12;

                    //workSheet.get_Range("A5", "O5").Font.Name = "Times New Roman";

                    workSheet.get_Range("A1", "O1000000").Columns.AutoFit();

                    workSheet.Activate();
                    workSheet.Application.ActiveWindow.SplitColumn = 2;
                    workSheet.Application.ActiveWindow.SplitRow = 3;
                    workSheet.Application.ActiveWindow.FreezePanes = true;




                    // check fielpath




                    if (ExcelFilePath != null && ExcelFilePath != "")
                    {

                        try
                        {


                            object misValue = System.Reflection.Missing.Value;
                            xlWorkBook.SaveAs(fileName, Excel.XlFileFormat.xlWorkbookNormal, misValue, misValue, misValue, misValue, Excel.XlSaveAsAccessMode.xlExclusive, misValue, misValue, misValue, misValue, misValue);
                            xlWorkBook.Close(true, misValue, misValue);

                            xlApp.Quit();

                            releaseObject(workSheet);
                            releaseObject(xlWorkBook);
                            releaseObject(xlApp);
                            //xlApp.Quit();

                            // MessageBox.Show("Excel file saved!");

                        }

                        catch (Exception ex)
                        {

                            CreateLogFiles Err = new CreateLogFiles();
                            Err.ErrorLog(ex.Message);
                        }
                    }
                }
                catch (Exception ex)
                {
                    CreateLogFiles Err = new CreateLogFiles();
                    Err.ErrorLog(ex.Message);
                }
            }

            return Json(fileName1, JsonRequestBehavior.AllowGet);

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
        public ExcelResult ExcelDownload(string file)
        {
            //var ExcelFilePath = "~/Content/";// ConfigurationManager.ConnectionStrings["Excel"].ToString();

            return new ExcelResult
            {
                FileName = file,
                Path = "~/ExcelSheets/" + file
            };

        }


    }
}
