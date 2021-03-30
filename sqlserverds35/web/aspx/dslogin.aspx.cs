
/*
* DVD Store Login ASPX Page for SQL Server - dslogin.aspx.cs
*
* Copyright (C) 2005 Dell, Inc. <dave_jaffe@dell.com> and <tmuirhead@vmware.com>
*
* Login to SQL Server DVD store 
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

namespace ds2
  {
  /// <summary>
  /// dslogin.aspx.cs: validates login to SQL Server DVD Store database
  /// Copyright 2005 Dell, Inc.
  /// Written by Todd Muirhead/Dave Jaffe      Last modified: 7/3/05
  /// </summary>
    
  public partial class dslogin : System.Web.UI.Page
    {
    protected void Page_Load(object sender, System.EventArgs e)
      {
      string username = null, password = null, conn_str = null;
      string form_str = null;
      int customerid = 0;
      SqlDataReader Rdr = null;
      SqlConnection objConn = null;

      Response.Write(dscommon.ds_html_header("DVD Store Login Page"));

      if (Request.QueryString.HasKeys())
        {
        username = Request.QueryString.GetValues("username")[0];
        }

      if (!(username == null))
        {
        password = Request.QueryString.GetValues("password")[0];
              
        conn_str = "User ID=sa;Initial Catalog=DS2;Data Source=localhost";
        objConn = new SqlConnection(conn_str);
        objConn.Open();       
 
        // Set up SQL stored procedure call and associated parameters
        SqlCommand Login = new SqlCommand("LOGIN", objConn);
        Login.CommandType = CommandType.StoredProcedure;
        Login.Parameters.Add("@username_in", SqlDbType.VarChar, 50);
        Login.Parameters.Add("@password_in", SqlDbType.VarChar, 50);       
        Login.Parameters["@username_in"].Value = username;
        Login.Parameters["@password_in"].Value = password;
       
        try 
          {
          Rdr = Login.ExecuteReader();
          Rdr.Read();
          customerid = Rdr.GetInt32(0);
          }
        catch (SqlException se) 
          {
          Response.Write("SQL Error " + se.Number + " in Login: " + se.Message);
          return;
          }

        if (customerid != 0)
          {
          Response.Write
            ("<H3>Welcome to the DVD Store - Click below to begin shopping</H3>\n");
          if (Rdr.NextResult() && Rdr.Read())  // There is a previous order
            {
            form_str = 
              "<H3>Your previous purchases:</H3>\n" +
              "<TABLE border=2>\n" +
              "<TR>\n" +
              "<TH>Title</TH>\n" +
              "<TH>Actor</TH>\n" +
              "<TH>People who liked this DVD also liked</TH>\n" +
              "</TR>\n";
            do
              {             
              form_str = form_str + " <TR><TD>" + Rdr.GetString(0)+ "</TD>";
              form_str = form_str + "<TD>" + Rdr.GetString(1)+ "</TD>";
              form_str = form_str + "<TD>" + Rdr.GetString(2)+ "</TD></TR>\n";
              } while(Rdr.Read());
            Rdr.Close();
            
            form_str = form_str + "</TABLE>\n" + "<BR>\n";
            Response.Write(form_str);
            } // End There is a previous order
          else  // There is no previous order
            {        
            }
            
          form_str =
            "<FORM ACTION=\"./dsbrowse.aspx\" METHOD=GET>\n" +
            "<INPUT TYPE=HIDDEN NAME=customerid VALUE=" + customerid + ">\n" +
            "<INPUT TYPE=SUBMIT VALUE=\"Start Shopping\">\n";
          Response.Write(form_str);
          } // End if (customerid != 0) 
        
        else // if customer not found
          {
          form_str = 
            "<H2>Username/password incorrect. Please re-enter your username and password</H2>\n" +
            "<FORM  ACTION=\"./dslogin.aspx\" METHOD=GET>\n" +
            "Username <INPUT TYPE=TEXT NAME=\"username\" VALUE='" + username + 
            "' SIZE=16 MAXLENGTH=24>\n" +    
            "Password <INPUT TYPE=PASSWORD NAME=\"password\" SIZE=16 MAXLENGTH=24>\n" + 
            "<INPUT TYPE=SUBMIT VALUE=\"Login\">\n" + 
            "</FORM>\n" + 
            "<H2>New customer? Please click New Customer</H2>\n" +
            "<FORM  ACTION=\"./dsnewcustomer.aspx\" METHOD=GET >\n" +
            "<INPUT TYPE=SUBMIT VALUE=\"New Customer\">\n" +
            "</FORM>\n";
          Response.Write(form_str);
          } // End if customer not found
        } // End if (!(username == null))
      
      else // if no username specified
        {
        form_str = 
          "<H2>Returning customer? Please enter your username and password</H2>\n" +
          "<FORM  ACTION=\"./dslogin.aspx\" METHOD=GET>\n" +
          "Username <INPUT TYPE=TEXT NAME=\"username\" SIZE=16 MAXLENGTH=24>\n" +    
          "Password <INPUT TYPE=PASSWORD NAME=\"password\" SIZE=16 MAXLENGTH=24>\n" + 
          "<INPUT TYPE=SUBMIT VALUE=\"Login\">\n" + 
          "</FORM>\n" + 
          "<H2>New customer? Please click New Customer</H2>\n" +
          "<FORM  ACTION=\"./dsnewcustomer.aspx\" METHOD=GET >\n" +
          "<INPUT TYPE=SUBMIT VALUE=\"New Customer\">\n" +
          "</FORM>\n";
        Response.Write(form_str);
        } // End if no username specified

      if (objConn != null) objConn.Close();
      Response.Write(dscommon.ds_html_footer());
      } // End Page_load        
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
    } // End Class dslogin
  } // End namespace ds2
