
<?php
/*  
 * DVD Store Login PHP Page - dslogin.php
 *
 * Copyright (C) 2005 Dell, Inc. <davejaffe7@gmail.com> and <tmuirhead@vmware.com>
 *
 * Login to MySQL DVD store 
 *
 * Last Updated 12/8/2021
 *
 * Support for PHP 7.4 and mysqli
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

include("dscommon.inc");

ds_html_header("DVD Store Login Page");

$username = $_REQUEST["username"];
$password = $_REQUEST["password"];
$storenum = $_REQUEST["storenum"];

if (!(empty($username)))
  {
  if (!($link_id = mysqli_connect())) die(mysqli_error());
  $query = "select CUSTOMERID FROM DS3.CUSTOMERS$storenum where USERNAME='$username' and PASSWORD='$password';";
  $result = mysqli_query($link_id,$query);
  if (mysqli_num_rows($result) > 0)
    {
    $row = mysqli_fetch_row($result);
    $customerid = $row[0];
    mysqli_free_result($result);
    echo "<H2>Welcome to the DVD Store - Click below to begin shopping</H2>\n";
    $query = "SELECT DS3.PRODUCTS$storenum.TITLE, DS3.PRODUCTS$storenum.ACTOR, DS3.PRODUCTS$storenum.COMMON_PROD_ID" .
             " FROM DS3.CUST_HIST$storenum INNER JOIN DS3.PRODUCTS$storenum ON DS3.CUST_HIST$storenum.PROD_ID = DS3.PRODUCTS$storenum.PROD_ID" .
             " WHERE DS3.CUST_HIST$storenum.CUSTOMERID =" . $customerid . " ORDER BY ORDERID DESC, TITLE ASC LIMIT 10;";
/*    mysqli_real_query($link_id, $query); */
    $result = mysqli_query($link_id,$query);

    if (mysqli_num_rows($result) > 0)
      {
      echo "<H3>Your previous purchases:</H3>\n";
      echo "<TABLE border=2>\n";
      echo "<TR>\n";
      echo "<TH>Title</TH>\n";
      echo "<TH>Actor</TH>\n";
      echo "<TH>People who liked this DVD also liked</TH>\n";
      echo "</TR>\n";

      while ($result_row = mysqli_fetch_row($result))
        {
        $query2 = "select TITLE from DS3.PRODUCTS$storenum where PROD_ID =" . $result_row[2] . ";";
/*        mysqli_real_query($link_id, $query2);*/
/*        $result2 = mysqli_store_result($link_id);*/
        $result2 = mysqli_query($link_id,$query2);
        $row2 = mysqli_fetch_row($result2);
        echo " <TR>\n";
        echo "<TD>$result_row[0]</TD>";
        echo "<TD>$result_row[1]</TD>";
        echo "<TD>$row2[0]</TD>";
        echo "</TR>\n";
        }
      echo "</TABLE>\n";
      echo "<BR>\n";
      }
    
    echo "<FORM ACTION=\"./dsbrowse.php\" METHOD=GET>\n";
    echo "<INPUT TYPE=HIDDEN NAME=customerid VALUE=$customerid>\n";
    echo "<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>\n";
    echo "<INPUT TYPE=SUBMIT VALUE=\"Start Shopping\">\n";
    echo "</FORM>\n";
    echo "<FORM ACTION=\"./dsnewmember.php\" METHOD=GET>\n";
    echo "<INPUT TYPE=HIDDEN NAME=customerid VALUE=$customerid>\n";
    echo "<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>\n";
    echo "<INPUT TYPE=SUBMIT VALUE=\"Premium Member Signup\">\n";

    mysqli_free_result($result);
    }
  else 
    {
    echo "<H2>Username/password incorrect. Please re-enter your username and password</H2>\n";
    echo "<FORM  ACTION=\"./dslogin.php\" METHOD=GET>\n";
    echo "Username <INPUT TYPE=TEXT NAME=\"username\" VALUE=$username SIZE=16 MAXLENGTH=24>\n";
    echo <<<EOT
Password <INPUT TYPE=PASSWORD NAME="password" SIZE=16 MAXLENGTH=24>
<INPUT TYPE=SUBMIT VALUE="Login"> 
</FORM>
<H2>New customer? Please click New Customer</H2>
<FORM  ACTION="./dsnewcustomer.php" METHOD=GET >
<INPUT TYPE=SUBMIT VALUE="New Customer"> 
<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>
</FORM>
EOT;
    }
  mysqli_close($link_id);
  }
else
  {
  echo <<<EOT
<H2>Returning customer? Please enter your username and password</H2>
<FORM  ACTION="./dslogin.php" METHOD=GET >
Username <INPUT TYPE=TEXT NAME="username" SIZE=16 MAXLENGTH=24>
Password <INPUT TYPE=PASSWORD NAME="password" SIZE=16 MAXLENGTH=24>
<INPUT TYPE=SUBMIT VALUE="Login"> 
<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>
</FORM>
<H2>New customer? Please click New Customer</H2>
<FORM  ACTION="./dsnewcustomer.php" METHOD=GET >
<INPUT TYPE=SUBMIT VALUE="New Customer"> 
<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>
</FORM>
EOT;
  }
ds_html_footer();
?>
