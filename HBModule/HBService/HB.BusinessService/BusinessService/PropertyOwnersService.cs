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
   public class PropertyOwnersService : IBusinessService
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
               DataSet dsHdr = new PropertyOwnersBO().Save(Hdrval, user); 
               if (dsHdr.Tables["DBERRORTBL"].Rows.Count > 0)
               {
                   dTable.Rows.Add(dsHdr.Tables["DBERRORTBL"].Rows[0][0].ToString());
               }
               else
               {
                   Int32 PrptyOwnerId  = Convert.ToInt32(dsHdr.Tables[0].Rows[0][0].ToString());
                   //string PrptyOwnerRowId = dsHdr.Tables[0].Rows[0][1].ToString();
                   string ApatmentId = dsHdr.Tables[0].Rows[0][1].ToString();  
                   string PrtyOwnerApartment = data[2].ToString();
                   DataSet ds1 = new PropertyOwnerApartmentBO().Save(ApatmentId,PrptyOwnerId, PrtyOwnerApartment, user);
                   string PrtyOwnerOtherContacts = data[3].ToString();
                   DataSet ds2 = new PropertyOwnerOtherContactsBO().Save(PrtyOwnerOtherContacts, user, PrptyOwnerId);
                   //if (ds1.Tables["DBERRORTBL"].Rows.Count > 0)
                   //{
                   //    dTable.R2ws.Add(ds1.Tables["DBERRORTBL"].Rows[0][0].ToString());
                   //}
               }
           }
           catch (Exception Ex)
           {
               CreateLogFilesService Err = new CreateLogFilesService();
               Err.ErrorLog(Ex.Message);
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

           DataSet ds1 = new PropertyOwnersBO().Delete(data, user);
           //if (ds1.Tables[0].Rows[0][0].ToString() == "Cant Be Deleted")
          // {
          //     dTable.Rows.Add("No Data for Deleteing This Category");
          // }
           ds.Tables.Add(dTable);
           return ds;
       }

       public DataSet Search(string[] data, User user)
       {
           return new PropertyOwnersBO().Search(data, user);
       }

       public DataSet HelpResult(string[] data, User user)
       {
           DataSet ds = new DataSet();
           DataTable dTable = new DataTable("ERRORTBL");
           dTable.Columns.Add("Exception");

           DataSet ds1 = new PropertyOwnersBO().Help(data, user);
           return ds1;
       }
   }
}