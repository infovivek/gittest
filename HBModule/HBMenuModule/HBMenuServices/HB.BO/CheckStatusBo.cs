using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.BO;
using System.Data;
using HB.Entity;
using HB.Dao;
using System.Collections;

namespace HB.BO
{
    public class CheckStatusBo
    {
        public string Checkstatus(int num)
        {
            return new CheckStatusDao().Checkstatus(num);
        }
        public DataSet ErrorHelp(string type, string[] data)
        {
            return new CheckStatusDao().ErrorHelp(type, data);
        }
    }
}
