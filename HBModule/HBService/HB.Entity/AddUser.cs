using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class AddUser
    {
        public int ClientId {get;set;}
        public string Title {get;set;}
        public string FirstName {get;set;}
        public string LastName {get;set;}
        public string Mobile {get;set;}
        public string Email {get;set;}
        public string Password {get;set;}
        public bool Active { get; set; }
        public int Id {get;set;}
    }
}

							