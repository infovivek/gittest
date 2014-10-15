using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;

namespace HB.BO
{
    public class RoomShiftBO
    {
        public DataSet HelpResult(string[] data, User user)
        {
            return new RoomShiftDao().HelpResult(data, user);
        }
    }
}
