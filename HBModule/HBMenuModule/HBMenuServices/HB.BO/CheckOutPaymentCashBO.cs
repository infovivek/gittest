﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class CheckOutPaymentCashBO
    {
        public DataSet Save(string Hdrval, User user)
        {
            return new CheckOutPaymentCashDao().Save(Hdrval, user);
        }
    }
}
