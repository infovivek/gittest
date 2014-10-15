using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using HB.Dao;

namespace HBService
{
    public partial class CodeGenerate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            { 
                DataSet dt = new DataSet();
                SqlCommand command = new SqlCommand();
                command.CommandText = "Codegenerate";
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@Id", SqlDbType.Int).Value = 0;
                dt = new WrbErpConnection().ExecuteDataSet(command, "");
               
                DropDownList1.DataSource = dt.Tables[0];

                DropDownList1.DataValueField = "data";
                DropDownList1.DataTextField = "Label";
                DropDownList1.DataBind();
            }
        }
 
        public String ClientId = "";
        protected void DropDownList1_TextChanged(object sender, EventArgs e)
        {
           // ClientId = DropDownList1.SelectedValue;

        }
        public string tex = "";
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropDownList1.SelectedItem.Text == "Select")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "script", "alert('Select Correct nest account...');", true);
            }
            else
            {
                tex = DropDownList1.SelectedItem.Text;
                ClientId = "booking.hummingbirdindia.com/EmployeeTravelRequest.php?HB!" + DropDownList1.SelectedValue +"-"+ tex.Substring(0, 3);
                txtCode.Text = ClientId;
            }
        }

        protected void Unnamed1_Click(object sender, EventArgs e)
        {
            if (DropDownList1.SelectedItem.Text =="Select")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "script", "alert('Select Correct nest account...');", true);
            }
            else
            {
                tex = DropDownList1.SelectedItem.Text;
                ClientId = "booking.hummingbirdindia.com/EmployeeTravelRequest.php?HB!" + DropDownList1.SelectedValue +"!"+ tex.Substring(0, 3);
                txtCode.Text = ClientId;
            }
        }
    }
}