
/*
* DVD Store New Customer ASPX Page for SQL Server - dsnewcustomer.aspx.cs
*
* Copyright (C) 2005 Dell, Inc. <dave_jaffe@dell.com> and <tmuirhead@vmware.com>
*
* Prompts for new customer data; creates new entry in SQL Server DVD Store CUSTOMERS table
*
* Last Updated 7/3/05
*
*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/


using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Threading;

namespace ds2
  {
  /// dsnewcustomer.aspx.cs: newcustomer login to SQL Server DVD Store database
  /// Copyright 2005 Dell, Inc.
  /// Written by Todd Muirhead/Dave Jaffe      Last modified: 7/3/05
    
  public partial class dsnewcustomer : System.Web.UI.Page
    {
    protected void Page_Load(object sender, System.EventArgs e)
      {
      string firstname="", lastname="", address1="", address2="", city="", state="",
        zip="", country="", email="", phone="", creditcardtype="",  creditcard="",
        ccexpmon="", ccexpyr="", username="", password="", age="",  income="", gender="";
      string form_str = null, conn_str = null, creditcardexpiration=null;
      int region=1, customerid=0;;

      SqlConnection objConn = null;
      
      Response.Write(dscommon.ds_html_header("DVD Store New Customer Page"));       
         
      if (Request.QueryString.HasKeys())
        {
        firstname =      Request.QueryString.GetValues("firstname")[0];
        lastname =       Request.QueryString.GetValues("lastname")[0];
        address1 =       Request.QueryString.GetValues("address1")[0];
        address2 =       Request.QueryString.GetValues("address2")[0];
        city =           Request.QueryString.GetValues("city")[0];
        state =          Request.QueryString.GetValues("state")[0];
        zip =            Request.QueryString.GetValues("zip")[0];
        country =        Request.QueryString.GetValues("country")[0];
        email =          Request.QueryString.GetValues("email")[0];
        phone =          Request.QueryString.GetValues("phone")[0];
        creditcardtype = Request.QueryString.GetValues("creditcardtype")[0];
        creditcard =     Request.QueryString.GetValues("creditcard")[0];
        ccexpmon =       Request.QueryString.GetValues("ccexpmon")[0];
        ccexpyr =        Request.QueryString.GetValues("ccexpyr")[0];
        username =       Request.QueryString.GetValues("username")[0];
        password =       Request.QueryString.GetValues("password")[0];
        age =            Request.QueryString.GetValues("age")[0];
        income =         Request.QueryString.GetValues("income")[0];
        gender =         Request.QueryString.GetValues("gender")[0];
        }
      
      if ((firstname!="") && (lastname!="") && (address1!="") && (city!="") && 
         (country!="") &&  (username!="") && (password!=""))
        {
        conn_str = "User ID=sa;Initial Catalog=DS2;Data Source=localhost";
        objConn = new SqlConnection(conn_str);
        objConn.Open(); 
                
        if (country != "US") region = 2;
        creditcardexpiration = String.Format("{0:D4}/{1:D2}", ccexpyr, 
          Convert.ToInt32(ccexpmon));
        
        SqlCommand New_Customer = new SqlCommand("NEW_CUSTOMER", objConn);
        New_Customer.CommandType = CommandType.StoredProcedure; 
        New_Customer.Parameters.Add("@username_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@password_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@firstname_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@lastname_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@address1_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@address2_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@city_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@state_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@zip_in", SqlDbType.Int);
        New_Customer.Parameters.Add("@country_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@region_in", SqlDbType.TinyInt);
        New_Customer.Parameters.Add("@email_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@phone_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@creditcardtype_in", SqlDbType.TinyInt);
        New_Customer.Parameters.Add("@creditcard_in", SqlDbType.VarChar, 50);
        New_Customer.Parameters.Add("@creditcardexpiration_in", SqlDbType.VarChar, 50); 
        New_Customer.Parameters.Add("@age_in", SqlDbType.TinyInt);
        New_Customer.Parameters.Add("@income_in", SqlDbType.Int);
        New_Customer.Parameters.Add("@gender_in", SqlDbType.VarChar, 1);
        
        New_Customer.Parameters["@username_in"].Value = username;
        New_Customer.Parameters["@password_in"].Value = password;
        New_Customer.Parameters["@firstname_in"].Value = firstname;
        New_Customer.Parameters["@lastname_in"].Value = lastname;
        New_Customer.Parameters["@address1_in"].Value = address1;
        New_Customer.Parameters["@address2_in"].Value = address2;
        New_Customer.Parameters["@city_in"].Value = city;
        New_Customer.Parameters["@state_in"].Value = state;
        New_Customer.Parameters["@zip_in"].Value = (zip=="") ? 0 : Convert.ToInt32(zip);
        New_Customer.Parameters["@country_in"].Value = country;
        New_Customer.Parameters["@region_in"].Value = region;
        New_Customer.Parameters["@email_in"].Value = email;
        New_Customer.Parameters["@phone_in"].Value = phone;
        New_Customer.Parameters["@creditcardtype_in"].Value = 
          (creditcardtype=="") ? 0 : Convert.ToInt32(creditcardtype);
        New_Customer.Parameters["@creditcard_in"].Value = creditcard;
        New_Customer.Parameters["@creditcardexpiration_in"].Value = creditcardexpiration;
        New_Customer.Parameters["@age_in"].Value = 
          (age=="") ? 0 : Convert.ToInt32(age);
        New_Customer.Parameters["@income_in"].Value = 
          (income=="") ? 0 : Convert.ToInt32(income);
        New_Customer.Parameters["@gender_in"].Value = gender;

        bool deadlocked;      
        do
          {
          try 
            {
            deadlocked = false;
            customerid = Convert.ToInt32(New_Customer.ExecuteScalar().ToString(), 10);
            }
          catch (SqlException se) 
            {
            if (se.Number == 1205)
              {
              deadlocked = true;
              Random r = new Random(DateTime.Now.Millisecond);
              int wait = r.Next(1000);
              Response.Write
                ("New_Customer deadlocked...waiting " + wait + " msec, then will retry");
              Thread.Sleep(wait); // Wait up to 1 sec, then try again
              }
            else
              {           
              Response.Write("SQL Error " + se.Number + " in New_Customer: " + se.Message);
              return;
              }
            }
          } while (deadlocked);
          
        if (customerid == 0) // Non-unique username
          {
          Response.Write("<H2>Username already in use! Please try another username</H2>\n");
          form_str = dsnewcustomer_form(firstname,  lastname,  address1, address2,  city,
            state,  zip,  country,  email, phone,  creditcardtype,  creditcard,  ccexpmon,
            ccexpyr, username,  password,  age,  income,  gender);
          Response.Write(form_str);
          }
        else  // unique username
          {
          form_str =
            "<H2>New Customer Successfully Added.  Click below to begin shopping<H2>\n";
          form_str = form_str + "<FORM ACTION='./dsbrowse.aspx' METHOD=GET>\n";
          form_str = form_str + "<INPUT TYPE=HIDDEN NAME=customerid VALUE="+customerid+
            ">\n";
          form_str = form_str + "<INPUT TYPE=SUBMIT VALUE='Start Shopping'>\n";
          form_str = form_str + "</FORM>\n";
          Response.Write(form_str);  
          } // End else - unique username
        } // End if (firstname!="") ...

      else // Incomplete customer info
        {
        Response.Write
         ("<H2>New Customer - Please Complete All Required Fields Below (marked with *)</H2>");
        form_str = dsnewcustomer_form(firstname,  lastname,  address1, address2,  city,
        state,  zip,  country,  email, phone,  creditcardtype,  creditcard,  ccexpmon,
        ccexpyr, username,  password,  age,  income,  gender);
        Response.Write(form_str);
        }

      if (objConn != null) objConn.Close();
      Response.Write(dscommon.ds_html_footer());        
      } // End Page_Load

        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
        }
        
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {    
        }
        #endregion
      
    
    private string dsnewcustomer_form(string firstname, string lastname, string address1,
      string address2, string city, string state, string zip, string country, string email,
      string phone, string creditcardtype, string creditcard, string ccexpmon,string ccexpyr,
      string username, string password, string age, string income, string gender)
      {
      int i, j, yr;
      bool gender_checked=false;
      string[] countries = new string[] {"United States", "Australia", "Canada", "Chile",
        "China", "France", "Germany", "Japan", "Russia", "South Africa", "UK"};
      string[] cctypes = new string[] {"MasterCard", "Visa", "Discover", "Amex",
        "Dell Preferred"};
      string[] months = new string[] {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
         "Sep", "Oct", "Nov", "Dec"};
      string form = "<FORM ACTION='./dsnewcustomer.aspx' METHOD='GET'>\n";
      form = form + "Firstname <INPUT TYPE=TEXT NAME='firstname' VALUE='" + firstname + 
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "Lastname <INPUT TYPE=TEXT NAME='lastname' VALUE='" + lastname + 
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "Address1 <INPUT TYPE=TEXT NAME='address1' VALUE='" + address1 +
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "Address2 <INPUT TYPE=TEXT NAME='address2' VALUE='" + address2 +
        "' SIZE=16 MAXLENGTH=50> <BR>\n";
      form = form + "City <INPUT TYPE=TEXT NAME='city' VALUE='" + city +
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "State <INPUT TYPE=TEXT NAME='state' VALUE='" + state +
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "Zipcode <INPUT TYPE=TEXT NAME='zip' VALUE='" + zip +
        "' SIZE=16 MAXLENGTH='5'> <BR>\n";
      
      form = form + "Country <SELECT NAME='country' SIZE=1>\n";
      for (i=0; i<countries.Length; i++)
        {
        if (countries[i] == country)
          form = form + "  <OPTION VALUE='" + countries[i] + "' SELECTED>" + countries[i] +
            "</OPTION>\n";
        else
          form = form + "  <OPTION VALUE='" + countries[i] + "'>" + countries[i] +
            "</OPTION>\n";
        }
      form = form + "</SELECT>* <BR>\n";
      form = form + "Email <INPUT TYPE=TEXT NAME='email' VALUE='" + email +
        "' SIZE=16 MAXLENGTH=50> <BR>\n";
      form = form + "Phone <INPUT TYPE=TEXT NAME='phone' VALUE='" + phone + 
        "' SIZE=16 MAXLENGTH=50> <BR>\n";
      
      form = form + "Credit Card Type "; 
      form = form + "<SELECT NAME='creditcardtype' SIZE=1>\n";
      for (i=0; i<5; i++)
        {
        j = i + 1;
        if ((creditcardtype!= "") && (j == Convert.ToInt32(creditcardtype)))
          form = form + "  <OPTION VALUE='" + j + "' SELECTED>" + cctypes[i] + "</OPTION>\n";
        else
          form = form + "  <OPTION VALUE='" + j + "'>" + cctypes[i] + "</OPTION>\n";
        }
      form = form + "</SELECT>\n";

      form = form + "  Credit Card Number <INPUT TYPE=TEXT NAME='creditcard' VALUE='" +
        creditcard + "' SIZE=16 MAXLENGTH=50>\n";

      form = form + "  Credit Card Expiration "; 
      form = form + "<SELECT NAME='ccexpmon' SIZE=1>\n";
      for (i=0; i<12; i++)
        {
        j = i+1;
        if ((ccexpmon != "") && (j == Convert.ToInt32(ccexpmon)))
          form = form + "  <OPTION VALUE='" + j + "' SELECTED>" + months[i] + "</OPTION>\n";
        else
          form = form + "  <OPTION VALUE='" + j + "'>" + months[i] + "</OPTION>\n";
        }
      form = form + "</SELECT>\n";
      form = form + "<SELECT NAME='ccexpyr' SIZE=1>\n";
      for (i=0; i<6; i++)
        {
        yr = 2008 + i;
        if ((ccexpyr != "") && (yr == Convert.ToInt32(ccexpyr)))
          form = form + "  <OPTION VALUE='"+ yr + "' SELECTED>" + yr + "</OPTION>\n";
        else
          form = form + "  <OPTION VALUE='" + yr + "'>" + yr + "</OPTION>\n";
        }
      form = form + "</SELECT><BR>\n";

      form = form + "Username <INPUT TYPE=TEXT NAME='username' VALUE='" + username + 
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "Password <INPUT TYPE=PASSWORD NAME='password' VALUE='" + password +
        "' SIZE=16 MAXLENGTH=50>* <BR>\n";
      form = form + "Age <INPUT TYPE=TEXT NAME='age' VALUE='" + age +
        "' SIZE=3 MAXLENGTH=3> <BR>\n";
      form = form + "Income ($US) <INPUT TYPE=TEXT NAME='income' VALUE='" + income + 
        "' SIZE=16 MAXLENGTH=50> <BR>\n";
      form = form + "Gender <INPUT TYPE=RADIO NAME='gender' VALUE=\"M\" "; 
        if (gender == "M") {form = form + "CHECKED"; gender_checked = true;}
        form = form + "> Male \n";
      form = form + "       <INPUT TYPE=RADIO NAME='gender' VALUE=\"F\" "; 
        if (gender == "F") {form = form + "CHECKED"; gender_checked = true;}
        form = form + "> Female \n";
      form = form + "       <INPUT TYPE=RADIO NAME='gender' VALUE=\"?\" ";
         if ((gender == "?") || (gender_checked==false)) form = form + "CHECKED";
         form = form + "> Don't Know <BR>\n";
         
      form = form + "<INPUT TYPE=SUBMIT VALUE='Submit New Customer Data'>\n";
      form = form + "</FORM>\n";
      return form;
      } // End dsnewcustomer_form
    } // End class dsnewcustomer
  } // End namespace ds2 
