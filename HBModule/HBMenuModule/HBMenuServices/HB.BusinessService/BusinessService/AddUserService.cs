using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Entity;
using System.Data;
using HB.BO;
using HB.BusinessService;

namespace HB.BusinessService.BusinessService
{
    public class AddUserService : IBusinessService
    {
        public DataSet Save(string[] data, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");
           try
           {
               string Hdrval;
               Hdrval = data[1].ToString();
               DataSet dsHdr = new AddUserBo().Save(Hdrval, user);

               if (dsHdr.Tables["DBERRORTBL"].Rows.Count > 0)
               {
                   dTable.Rows.Add(dsHdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
               }
             else 
               {
                   if (dsHdr.Tables[0].Rows[0][0].ToString() == "Email Already Exists")
                   {
                       dTable.Rows.Add("Email Already Exists");
                   }
                   if (dsHdr.Tables[0].Rows[0][0].ToString() == "Mobile Already Exists")
                   {
                       dTable.Rows.Add("Mobile Already Exists");
                   }
                   
               }
            }
            catch (Exception Ex)
            {
                CreateLogFilesService Err = new CreateLogFilesService();
                Err.ErrorLog( Ex.Message);
                dTable.Rows.Add("Error - " + Ex.Message + " | " + Ex.InnerException);
            }
            finally
            {
                ds.Tables.Add(dTable);
                dTable.Dispose();
                dTable = null;
            }
            return ds;
        }
       public DataSet Delete(string[] data, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");

           DataSet ds1 = new AddUserBo().Delete(data, user);
           //if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
           //{
           //    dTable.Rows.Add("No Data for Deleteing This Category");
           //}
           ds.Tables.Add(dTable);
           return ds;
       }

       public DataSet Search(string[] data, User user)
       {
           return new AddUserBo().Search(data, user);
       }

       public DataSet HelpResult(string[] data, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");

           DataSet ds1 = new AddUserBo().Help(data, user);
           return ds1;
       } 
    }
  }
