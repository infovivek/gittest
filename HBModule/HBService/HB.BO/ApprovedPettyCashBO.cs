﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
    public class ApprovedPettyCashBO
    {
         public DataSet Save(string[] data, User user)
        {
            return new ApprovedPettyCasDAO().Save(data, user);
        }
    }
}
