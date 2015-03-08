using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class ProformainvoiceServicehdrBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            return new ProformainvoiceServicehdrDao().Save(Hdrval, user);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new ProformainvoiceServicehdrDao().HelpResult(data, user);
        } 
    }
}
