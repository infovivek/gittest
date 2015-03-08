using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class PreformaInvoiceEXTMMTCPPchkoutBO
    {
        public DataSet Save(string[] data, User User)
        {
            return new PreformaInvoiceEXTMMTCPPchkoutDao().Save(data, User);
        }
        public DataSet Search(string[] data, User user)
        {
            return new PreformaInvoiceEXTMMTCPPchkoutDao().Search(data, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new PreformaInvoiceEXTMMTCPPchkoutDao().HelpResult(data, user);
        }
    }
}
