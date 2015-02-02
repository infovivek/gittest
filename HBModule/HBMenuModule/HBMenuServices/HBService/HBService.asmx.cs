using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services; 
using System.Xml;
using HB.Entity;
using HB.BO;
using HB.BusinessService;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Drawing;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;

namespace HBService
{
    public class HBService : System.Web.Services.WebService
    {
        [WebMethod]
        public DataSet Save(String type, string[] data)
        {
            DataSet ds = new DataSet();
            User user = new User();
            user = user.ExtractHdrData(data[0].ToString());
            BusinessServiceFactory factory = new BusinessServiceFactory();
            var businessService = factory.Create(type);
            ds = businessService.Save(data, user);
            return ds;
        }
        [WebMethod]
        public DataSet Delete(String type, string[] data)
        {
            DataSet dsResult = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            User user = new User();
            user = user.ExtractHdrData(data[0].ToString());
            BusinessServiceFactory factory = new BusinessServiceFactory();
            var businessFactory = factory.Create(type);
            dsResult = businessFactory.Delete(data, user);
            return dsResult;
        }

        [WebMethod]
        public DataSet HelpResult(String type, string[] data)
        {
            DataSet dsResult = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            User user = new User();
            user = user.ExtractHdrData(data[0].ToString());
            BusinessServiceFactory factory = new BusinessServiceFactory();
            var businessFactory = factory.Create(type);
            dsResult = businessFactory.HelpResult(data, user);
            dTable.Columns.Add("Exception");
            if (dsResult.Tables["DBERRORTBL"].Rows.Count > 0)
            {
                dTable.Rows.Add(dsResult.Tables["DBERRORTBL"].Rows[0][0].ToString());
            }
            dsResult.Tables.Add(dTable);
            return dsResult;
        }
        [WebMethod]
        public DataSet SearchResult(String type, string[] data)
        {
            DataSet dsResult = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            User user = new User();
            user = user.ExtractHdrData(data[0].ToString());
            BusinessServiceFactory factory = new BusinessServiceFactory();
            var businessFactory = factory.Create(type);
            dsResult = businessFactory.Search(data, user);
            dTable.Columns.Add("Exception");
            if (dsResult.Tables["DBERRORTBL"].Rows.Count > 0)
            {
                dTable.Rows.Add(dsResult.Tables["DBERRORTBL"].Rows[0][0].ToString());
            }
            dsResult.Tables.Add(dTable);
            return dsResult;
        }
        [WebMethod]
        public DataSet ErrorHelp(String type, string[] data)
        {
            DataSet dsResult = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            User user = new User();
            user = user.ExtractHdrData(data[0].ToString());
            DataSet ds = new DataSet();
            dTable.Columns.Add("Exception");
            if (dsResult.Tables["DBERRORTBL"].Rows.Count > 0)
            {
                dTable.Rows.Add(dsResult.Tables["DBERRORTBL"].Rows[0][0].ToString());
            }
            ds = new CheckStatusBo().ErrorHelp(type, data);
            ds.Tables.Add(dTable);
            return ds;
        }
        [WebMethod(CacheDuration = 30,
         Description = "Returns Checking Data From Database")]
        public string Checkstatus(int num)
        {
            DataSet dsResult = new DataSet();
            DataTable dTable = new DataTable("ERRORTBL");
            DataSet ds = new DataSet();
            string var = new CheckStatusBo().Checkstatus(num);
            return var;
        }

        private string sLogFormat;
        private string sErrorTime;
        public void CreateLogFiles(string Query)
        {
            sLogFormat = DateTime.Now.ToShortDateString().ToString() + " " + DateTime.Now.ToLongTimeString().ToString() + " ==> ";
            string sYear = DateTime.Now.Year.ToString();
            string sMonth = DateTime.Now.Month.ToString();
            string sDay = DateTime.Now.Day.ToString();
            sErrorTime = sYear + sMonth + sDay;
            ErrorLog(Query);
        }

        public void ErrorLog(string sErrMsg)
        {
            StreamWriter sw = new StreamWriter(ConfigurationManager.ConnectionStrings["Log"].ToString() + sErrorTime, true);
            sw.WriteLine(sLogFormat + sErrMsg);
            sw.Flush();
            sw.Close();
        }
    }
}