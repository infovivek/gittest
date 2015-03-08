using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using test1.DAO;
using test1.Models;
namespace test1.ActionResults
{
    public class ExcelResult : ActionResult
    {
        public string FileName { get; set; }
        public string Path { get; set; }

        public override void ExecuteResult(ControllerContext context)
        {
            try
            {
                context.HttpContext.Response.Buffer = true;
                context.HttpContext.Response.Clear();
                context.HttpContext.Response.AddHeader("content-disposition", "attachment; filename=" + FileName);
                context.HttpContext.Response.ContentType = "application/vnd.ms-excel";
                context.HttpContext.Response.WriteFile(context.HttpContext.Server.MapPath(Path));
            }
            catch (Exception ex)
            {
                CreateLogFiles Err = new CreateLogFiles();
                Err.ErrorLog(ex.Message);

            }
            finally
            {
                CreateLogFiles Err = new CreateLogFiles();
                Err.ErrorLog("Sucess");
            }
        }
    }
}