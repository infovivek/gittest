using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Collections;


namespace HB.Entity
{
    public class User
    {
        public string Id { get; set; }
        public string LoginUserName { get; set; }
        public int UserGroupId { get; set; }
        public string UserCode { get; set; }
        public string UserGroup { get; set; }
        public string Password { get; set; }
        public int SctId { get; set; }
        public string ScreenName { get; set; }
        public int BranchId { get; set; }
        public User CreatedBy { get; set; }
        public User ModifiedBy { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public Guid RowId { get; set; }

        public User ExtractHdrData(string data)
        {
            XmlDocument document = new XmlDocument();
            document.LoadXml(data);
            User user = new User();
            user.Id = document.SelectSingleNode("//GlobalXml").Attributes["UsrId"].Value;
            user.LoginUserName = document.SelectSingleNode("//GlobalXml").Attributes["UsrName"].Value;
            user.SctId = Convert.ToInt32(document.SelectSingleNode("//GlobalXml").Attributes["SctId"].Value);
            user.ScreenName = document.SelectSingleNode("//GlobalXml").Attributes["ScrNM"].Value;
            return user;
        }
    }
}
