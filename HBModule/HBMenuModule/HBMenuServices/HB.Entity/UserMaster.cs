using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
  public class UserMaster
    {
       
        public string Title { get; set; }
        public string UserName { get; set; } 
        public string UserPassword { get; set; }
        public string Email { get; set; } 
        public string FirstName { get; set; } 
        public string LastName { get; set; }
        public string Address { get; set; }
        public string State { get; set; }
        public string City { get; set; }
        public string Zip { get; set; }
        public string PhoneNumber { get; set; }
        public string MobileNumber  { get; set; }
        public string UserGroup { get; set; }
        public string UserRoles { get; set; }
        public string CountId { get; set; }

        public int EmployeeID  { get; set; }
        public User CreatedBy { get; set; } 
        public User ModifiedBy { get; set; }
        public int Id { get; set; } 
        public bool IsActive { get; set; } 
        public bool IsDeleted { get; set; }

        public string UserId { get; set; }
        public string RoleId { get; set; }
        public string Roles { get; set; }
    }
}
