using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HB.Dao;
using HB.Entity;
using System.Data;

namespace HB.BO
{
    public class CheckInDtlsBo
    {

        public DataSet Save(string ChkInHdr, User user, int ChkInHdrId)
        {
            return new CheckInDtlsDAO().Save(ChkInHdr, user, ChkInHdrId);
        }
        public DataSet HelpResult(string[] data, User user)
        {
            return new CheckInDtlsDAO().HelpResult(data, user);
        }
    }

 }

