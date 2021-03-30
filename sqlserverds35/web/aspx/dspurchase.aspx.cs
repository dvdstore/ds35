
/*
* DVD Store Purchase ASPX Page for SQL Server - dspurchase.aspx.cs
*
* Copyright (C) 2005 Dell, Inc. <dave_jaffe@dell.com> and <tmuirhead@vmware.com>
*
* Handles purchase of DVDs for SQL Server DVD Store database
* Checks inventories, adds records to ORDERS and ORDERLINES tables transactionally
*
* Last Updated 7/3/05
* Last updated 6/29/2010  by GSK for parameterizing query (Improves query caching performance on SQL server)
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
  /// dspurchase.aspx.cs: purchase application for SQL Server DVD Store database
  /// Copyright 2005 Dell, Inc.
  /// Written by Todd Muirhead/Dave Jaffe      Last modified: 7/3/05
  /// //Last Modified : 6/29/2010 by GSK (parameterization of queries)
    
  public partial class dspurchase : System.Web.UI.Page
    {
    protected void Page_Load(object sender, System.EventArgs e)
      {
      string customerid="", confirmpurchase="";
      string form_str = null, conn_str = null, db_query = null;
      int i, j, item_len = 0, quan_len = 0, drop_len = 0, orderid = 0, cart_items;
      int[] item = new int[20];
      int[] quan = new int[20];
      int[] drop = new int[20];
      double netamount = 0, totalamount, taxamount, taxpct;
      string amt, netamount_fmt, totalamount_fmt, taxamount_fmt;
      
      SqlCommand cmd = null;    
      SqlConnection objConn = null;
      SqlDataReader Rdr = null;
      bool conn_open = false;
      string[] cctypes = new string[]{"MasterCard", "Visa", "Discover", "Amex", 
        "Dell Preferred"};

      Response.Write(dscommon.ds_html_header("DVD Store Purchase Page"));       
         
      if (Request.QueryString.HasKeys())
        {
        if (Array.IndexOf(Request.QueryString.AllKeys, "customerid") >= 0) 
          customerid = Request.QueryString.GetValues("customerid")[0];
        if (Array.IndexOf(Request.QueryString.AllKeys, "confirmpurchase") >= 0) 
          confirmpurchase = Request.QueryString.GetValues("confirmpurchase")[0];
        if (Array.IndexOf(Request.QueryString.AllKeys, "item") >= 0) 
          {
          //Response.Write("item<BR>");
          item_len = Request.QueryString.GetValues("item").Length;
          for (i=0; i<item_len; i++)
            { 
            item[i] = Convert.ToInt32(Request.QueryString.GetValues("item")[i]);
            //Response.Write(i + " " + item[i] + "<BR>");
            }
          }
            
        if (Array.IndexOf(Request.QueryString.AllKeys, "quan") >= 0) 
          {
          //Response.Write("quan<BR>");
          quan_len = Request.QueryString.GetValues("quan").Length;
          for (i=0; i<quan_len; i++)
            { 
            quan[i] = Convert.ToInt32(Request.QueryString.GetValues("quan")[i]);
            //Response.Write(i + " " + quan[i] + "<BR>");
            }
          }
            
        if (Array.IndexOf(Request.QueryString.AllKeys, "drop") >= 0) 
          {
          //Response.Write("drop<BR>");
          drop_len = Request.QueryString.GetValues("drop").Length;
          for (i=0; i<drop_len; i++)
            { 
            drop[i] = Convert.ToInt32(Request.QueryString.GetValues("drop")[i]);
            //Response.Write(i + " " + drop[i] + "<BR>");
            }
          }
        } // End if (Request.QueryString.HasKeys())
      
      if (confirmpurchase=="") // Confirm purchase not selected
        {
        form_str = "<H2>Selected Items: specify quantity desired and click Update;" +
          " click Purchase when finished</H2>\n";
        form_str = form_str + "<BR>\n";
        form_str = form_str + "<FORM ACTION='./dspurchase.aspx' METHOD='GET'>\n";
        form_str = form_str + "<TABLE border=2>\n";
        form_str = form_str + "<TR>\n";
        form_str = form_str + "<TH>Item</TH>\n";
        form_str = form_str + "<TH>Quantity</TH>\n";
        form_str = form_str + "<TH>Title</TH>\n";
        form_str = form_str + "<TH>Actor</TH>\n";
        form_str = form_str + "<TH>Price</TH>\n";
        form_str = form_str + "<TH>Remove From Order?</TH>\n";
        form_str = form_str + "</TR>\n";
      
        conn_str = "User ID=sa;Initial Catalog=DS2;Data Source=localhost";
        objConn = new SqlConnection(conn_str);
        objConn.Open();
        conn_open = true; 
              
        j = 0;
        for (i=0; i<item_len; i++)
          {
          if ((drop_len==0) || (Array.IndexOf(drop,i+1)<0))
            {
            ++j;
            //Commented by GSK
            //db_query = "select PROD_ID, TITLE, ACTOR, PRICE from PRODUCTS where " +
            //  "PROD_ID=" + item[i] + ";";

            //Modified by GSK to parameterized query
            db_query = "select PROD_ID, TITLE, ACTOR, PRICE from PRODUCTS where " +
              "PROD_ID= @ARG" + ";";

            //Response.Write("db_query= " + db_query);
            cmd = new SqlCommand ( db_query , objConn );
            cmd.Parameters.Add ("@ARG", SqlDbType.Int );
            cmd.Parameters["@ARG"].Value = item[i];

            
            Rdr = cmd.ExecuteReader();
            Rdr.Read();
            form_str = form_str + " <TR>";
            form_str = form_str + "<TD ALIGN=CENTER>" + j + "</TD>";
            form_str = form_str + "<INPUT NAME='item' TYPE=HIDDEN VALUE=" +
              Rdr.GetInt32(0) + "></TD>";
            form_str = form_str + "<TD><INPUT NAME='quan' TYPE=TEXT SIZE=10 VALUE=" +
              Math.Max(1,quan[i]) + "></TD>";          
            form_str = form_str + "<TD>" + Rdr.GetString(1) + "</TD>";
            form_str = form_str + "<TD>" + Rdr.GetString(2) + "</TD>";
            amt = String.Format("{0:F2}", Rdr.GetDecimal(3));
            form_str = form_str + "<TD ALIGN=RIGHT>" + amt + "</TD>";                              
            form_str = form_str + "<TD ALIGN=CENTER><INPUT NAME='drop' TYPE=CHECKBOX " +
              "VALUE=" + j + "></TD>";
            form_str = form_str + "</TR>\n";
            
            netamount = netamount + Math.Max(1,quan[i])*(double)Rdr.GetDecimal(3);

            Rdr.Close();
            } // End if ((drop_len==0) || (Array.IndexOf(drop,i)<0))
          } // End for (i=0; i<item_len; i++)   

        taxpct = 8.25;
        taxamount = netamount * taxpct/100.0;
        totalamount = taxamount + netamount;
        amt = String.Format("{0:F2}", netamount);
        form_str = form_str +"<TR><TD></TD><TD></TD><TD></TD><TD>Subtotal</TD><TD ALIGN=" + 
          "RIGHT>" + amt + "</TD></TR>\n";
        amt = String.Format("{0:F2}", taxamount);
        form_str = form_str + 
          "<TR><TD></TD><TD></TD><TD></TD><TD>Tax (" + taxpct + "%)</TD>" + 
          "<TD ALIGN=RIGHT>" + amt + "</TD></TR>\n";
        amt = String.Format("{0:F2}", totalamount);
        form_str = form_str + "<TR><TD></TD><TD></TD><TD></TD><TD>Total</TD><TD ALIGN=" +
          "RIGHT>" + amt + "</TD></TR>\n";
        form_str = form_str + "</TABLE><BR>\n";
          
        form_str = form_str + "<INPUT TYPE=HIDDEN NAME=customerid VALUE="+customerid+">\n";
      
        form_str = form_str + "<INPUT TYPE=SUBMIT VALUE='Update and Recalculate Total'>\n";
        form_str = form_str + "</FORM><BR>\n";
        
        form_str = form_str + "<FORM ACTION='./dspurchase.aspx' METHOD='GET'>\n";
        form_str = form_str + "<INPUT TYPE=HIDDEN NAME=confirmpurchase VALUE='yes'>\n";
        form_str = form_str + "<INPUT TYPE=HIDDEN NAME=customerid VALUE="+customerid+">\n";
        for (i=0; i<item_len; i++)
          {
          if ((drop_len==0) || (Array.IndexOf(drop,i)<0))
            {
            form_str = form_str + "<INPUT NAME='item' TYPE=HIDDEN VALUE=" + item[i] + ">";
            form_str = form_str + "<INPUT NAME='quan' TYPE=HIDDEN VALUE=" + quan[i] + ">\n";
            }
          }      
        form_str = form_str + "<INPUT TYPE=SUBMIT VALUE='Purchase'>\n";

        Response.Write(form_str);
                 
        } // End Confirm purchase not selected
          
      else // Confirm purchase
        {                    
        //Cap cart_items at 10 for this implementation of stored procedure
        cart_items = System.Math.Min(10, item_len);
            
        form_str = form_str + "<H2>Purchase complete</H2>\n";
        form_str = form_str + "<TABLE border=2>";
        form_str = form_str + "<TR>";
        form_str = form_str + "<TH>Item</TH>";
        form_str = form_str + "<TH>Quantity</TH>";
        form_str = form_str + "<TH>Title</TH>";
        form_str = form_str + "<TH>Actor</TH>";
        form_str = form_str + "<TH>Price</TH>";
        form_str = form_str + "</TR>\n";
      
        if (!conn_open)
          {
          conn_str = "User ID=sa;Initial Catalog=DS2;Data Source=localhost";
          objConn = new SqlConnection(conn_str);
          objConn.Open();
          conn_open = true; 
          }        
        
        for (i=0; i<cart_items; i++)
          {
          //Commented by GSK
          //db_query = "select TITLE, ACTOR, PRICE from PRODUCTS where " +
          //  "PROD_ID=" + item[i] + ";";

          //Modified by GSK to parameterized query
          db_query = "select TITLE, ACTOR, PRICE from PRODUCTS where " +
            "PROD_ID= @ARG" + ";";

          //Response.Write("db_query= " + db_query +"<br>");      
          cmd = new SqlCommand(db_query, objConn);          
          cmd.Parameters.Add ( "@ARG" , SqlDbType.Int );
          cmd.Parameters["@ARG"].Value = item[i];


          Rdr = cmd.ExecuteReader();
          Rdr.Read();
          form_str = form_str + " <TR>";
          form_str = form_str + "<TD ALIGN=CENTER>" + (i+1) + "</TD>";
          form_str = form_str + "<TD>" + Math.Max(1,quan[i]) + "</TD>";          
          form_str = form_str + "<TD>" + Rdr.GetString(0) + "</TD>";
          form_str = form_str + "<TD>" + Rdr.GetString(1) + "</TD>";
          amt = String.Format("{0:F2}", Rdr.GetDecimal(2));
          form_str = form_str + "<TD ALIGN=RIGHT>" + amt + "</TD>";        
          form_str = form_str + "</TR>\n";       
          netamount = netamount + Math.Max(1,quan[i])*(double)Rdr.GetDecimal(2);
          Rdr.Close();
          } // End for (i=0; i<cart_items; i++)   

        taxpct = 8.25;
        taxamount = netamount * taxpct/100.0;
        totalamount = taxamount + netamount;
        netamount_fmt = String.Format("{0:F2}", netamount);
        form_str = form_str +"<TR><TD></TD><TD></TD><TD></TD><TD>Subtotal</TD><TD ALIGN=" + 
          "RIGHT>" + netamount_fmt + "</TD></TR>\n";
        taxamount_fmt = String.Format("{0:F2}", taxamount);
        form_str = form_str + 
          "<TR><TD></TD><TD></TD><TD></TD><TD>Tax (" + taxpct + "%)</TD>" +
          "<TD ALIGN=RIGHT>" + taxamount_fmt + "</TD></TR>\n";
        totalamount_fmt = String.Format("{0:F2}", totalamount);
        form_str = form_str + "<TR><TD></TD><TD></TD><TD></TD><TD>Total</TD><TD ALIGN=" +
          "RIGHT>" + totalamount_fmt + "</TD></TR>\n";
        form_str = form_str + "</TABLE><BR>\n";

        SqlCommand Purchase = new SqlCommand("PURCHASE", objConn);
        Purchase.CommandType = CommandType.StoredProcedure; 
        
        Purchase.Parameters.Add("@customerid_in", SqlDbType.Int);
        Purchase.Parameters.Add("@number_items", SqlDbType.Int);
        Purchase.Parameters.Add("@netamount_in", SqlDbType.Money);
        Purchase.Parameters.Add("@taxamount_in", SqlDbType.Money);
        Purchase.Parameters.Add("@totalamount_in", SqlDbType.Money);
        Purchase.Parameters.Add("@prod_id_in0", SqlDbType.Int);
        Purchase.Parameters.Add("@qty_in0", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in1", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in1", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in2", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in2", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in3", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in3", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in4", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in4", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in5", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in5", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in6", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in6", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in7", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in7", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in8", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in8", SqlDbType.Int);
        Purchase.Parameters.Add("@prod_id_in9", SqlDbType.Int); 
        Purchase.Parameters.Add("@qty_in9", SqlDbType.Int);
           
        Purchase.Parameters["@customerid_in"].Value = customerid;
        Purchase.Parameters["@number_items"].Value = cart_items;
        Purchase.Parameters["@netamount_in"].Value = netamount;
        Purchase.Parameters["@taxamount_in"].Value = taxamount;
        Purchase.Parameters["@totalamount_in"].Value = totalamount;
        Purchase.Parameters["@prod_id_in0"].Value = item[0]; 
        Purchase.Parameters["@qty_in0"].Value = quan[0];
        Purchase.Parameters["@prod_id_in1"].Value = item[1]; 
        Purchase.Parameters["@qty_in1"].Value = quan[1];
        Purchase.Parameters["@prod_id_in2"].Value = item[2]; 
        Purchase.Parameters["@qty_in2"].Value = quan[2];
        Purchase.Parameters["@prod_id_in3"].Value = item[3]; 
        Purchase.Parameters["@qty_in3"].Value = quan[3];
        Purchase.Parameters["@prod_id_in4"].Value = item[4]; 
        Purchase.Parameters["@qty_in4"].Value = quan[4];
        Purchase.Parameters["@prod_id_in5"].Value = item[5]; 
        Purchase.Parameters["@qty_in5"].Value = quan[5];
        Purchase.Parameters["@prod_id_in6"].Value = item[6]; 
        Purchase.Parameters["@qty_in6"].Value = quan[6];
        Purchase.Parameters["@prod_id_in7"].Value = item[7]; 
        Purchase.Parameters["@qty_in7"].Value = quan[7];
        Purchase.Parameters["@prod_id_in8"].Value = item[8]; 
        Purchase.Parameters["@qty_in8"].Value = quan[8];
        Purchase.Parameters["@prod_id_in9"].Value = item[9]; 
        Purchase.Parameters["@qty_in9"].Value = quan[9];

        bool deadlocked;      
        do
          {
          try 
            {
            deadlocked = false;
            orderid = (int) Purchase.ExecuteScalar();
            }
          catch (SqlException se) 
            {
            if (se.Number == 1205)
              {
              deadlocked = true;
              Random r = new Random(DateTime.Now.Millisecond);
              int wait = r.Next(1000);
              Response.Write
                ("Purchase deadlocked...waiting " + wait + " msec, then will retry");
              Thread.Sleep(wait); // Wait up to 1 sec, then try again
              }
            else
              {           
              Response.Write("SQL Error " + se.Number + " in Purchase: " + se.Message);
              return;
              }
            }
          } while (deadlocked);     
        
        if (orderid > 0) // Purchase was successful
          {
          // To Do: verify credit card purchase against a second database
          //Commented by GSK  
          //db_query = "select CREDITCARDTYPE, CREDITCARD, CREDITCARDEXPIRATION " +
          //  "from CUSTOMERS where CUSTOMERID=" + customerid + ";";
          //cmd = new SqlCommand ( db_query , objConn );
          //Modified by GSK for parameterizing query
          db_query = "select CREDITCARDTYPE, CREDITCARD, CREDITCARDEXPIRATION " +
          "from CUSTOMERS where CUSTOMERID= @ARG" + ";";
          cmd = new SqlCommand ( db_query , objConn );
          cmd.Parameters.Add ( "@ARG" , SqlDbType.Int );
          cmd.Parameters["@ARG"].Value = customerid;
          
          Rdr = cmd.ExecuteReader();
          Rdr.Read();
          form_str = form_str + "<H3>" + totalamount_fmt + " charged to credit card " +
            Rdr.GetString(1) + "(" + cctypes[Rdr.GetByte(0)-1] + "). " +
            "Expiration: " + Rdr.GetString(2) + "</H3><BR>\n";
          form_str = form_str + "<H2>Order Completed Successfully --- ORDER NUMBER:" +
            orderid + "</H2><BR>\n";
          }
        else
          {
          form_str = form_str + "<H3>Insufficient stock - order not processed</H3>\n";
          }
        Response.Write(form_str);      
        } // End Confirm purchase
          
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
    
    } // End class dspurchase
  } // End namespace ds2 
