using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using HB.Dao;
using HB.Entity;


namespace HB.BO
{
   public class PropertyRoomBedsBO
    {

       public DataSet Save(int RoomId, string PrtyRoomBeds, User user)
        {
            return new PropertyRoomBedsDAO().Save(RoomId, PrtyRoomBeds, user);
        }
        public DataSet Search(string[] data, User user)
        {
            return new PropertyRoomBedsDAO().Search(data, user);
        }
        public DataSet Delete(string[] data, User user)
        {
            return new PropertyRoomBedsDAO().Delete(data, user);
        }
        public DataSet Help(string[] data, User user)
        {
            return new PropertyRoomBedsDAO().Help(data, user);
        }

    }
}
