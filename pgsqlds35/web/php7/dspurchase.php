
<?php
/*  
 * DVD Store Purchase PHP Postgresql Page - dspurchase.php
 *
 * Copyright (C) 2005 Dell, Inc. <dave_jaffe@dell.com> and <tmuirhead@vmware.com>
 *
 * Handles purchase of DVDs for Postgresql DVD Store database
 * Checks inventories, adds records to ORDERS and ORDERLINES tables transactionally
 *
 * Last Updated 12/16/21
 *
 * Support for PHP 7.4 and pgsql
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

ds_html_header("DVD Store Purchase Page");

$confirmpurchase = isset($_REQUEST["confirmpurchase"]) ? $_REQUEST["confirmpurchase"] : NULL;
$item = isset($_REQUEST["item"]) ? $_REQUEST["item"] : NULL;
$quan = isset($_REQUEST["quan"]) ? $_REQUEST["quan"] : NULL;
$drop = isset($_REQUEST["drop"]) ? $_REQUEST["drop"] : NULL;
// $drop = $_REQUEST["drop"];
$customerid = $_REQUEST["customerid"];
$storenum = $_REQUEST["storenum"];
$netamount = 0;

if (empty($confirmpurchase))
  {
  echo "<H2>Selected Items: specify quantity desired; click Purchase when finished</H2>\n";
  echo "<BR>\n";
  echo "<FORM ACTION='./dspurchase.php' METHOD='GET'>\n";
  echo "<TABLE border=2>\n";
  echo "<TR>\n";
  echo "<TH>Item</TH>\n";
  echo "<TH>Quantity</TH>\n";
  echo "<TH>Title</TH>\n";
  echo "<TH>Actor</TH>\n";
  echo "<TH>Price</TH>\n";
  echo "<TH>Remove From Order?</TH>\n";
  echo "</TR>\n";

  if (!($link_id = pg_connect($connstr))) die(pg_last_error());

  $j = 0;
  for ($i=0; $i<count($item); $i++)
    {
    if (empty($drop) || !in_array($i, $drop))
      {
      ++$j;
      $purchase_query = "select PROD_ID, TITLE, ACTOR, PRICE from PRODUCTS$storenum where PROD_ID=$item[$i]";
      $purchase_result = pg_query($link_id,$purchase_query);
      $purchase_result_row = pg_fetch_row($purchase_result);
      pg_free_result($purchase_result);
      echo " <TR>";
      echo "<TD ALIGN=CENTER>$j</TD>";
      echo "<INPUT NAME='item[]' TYPE='HIDDEN' VALUE='$purchase_result_row[0]'>";
      echo "<TD><INPUT NAME='quan[]' TYPE='TEXT' SIZE=10 VALUE=" . max(1,$quan[$i]) . "></TD>";
      echo "<TD>$purchase_result_row[1]</TD>";
      echo "<TD>$purchase_result_row[2]</TD>";
      $amt = sprintf("$%.2f", $purchase_result_row[3]);
      echo "<TD ALIGN=RIGHT>$amt</TD>";
      echo "<TD ALIGN=CENTER><INPUT NAME='drop[]' TYPE=CHECKBOX VALUE=$i></TD>";
      echo "</TR>\n";
      $netamount = $netamount + max(1,$quan[$i])*$purchase_result_row[3];
      }
    }      

  $taxpct = 8.25;
  $taxamount = $netamount * $taxpct/100.0;
  $totalamount = $taxamount + $netamount;
  $amt = sprintf("$%.2f", $netamount);
  echo "<TR><TD></TD><TD></TD><TD></TD><TD>Subtotal</TD><TD ALIGN=RIGHT>$amt</TD></TR>\n";
  $amt = sprintf("$%.2f", $taxamount);
  echo "<TR><TD></TD><TD></TD><TD></TD><TD>Tax ($taxpct%)</TD><TD ALIGN=RIGHT>$amt</TD></TR>\n";
  $amt = sprintf("$%.2f", $totalamount);
  echo "<TR><TD></TD><TD></TD><TD></TD><TD>Total</TD><TD ALIGN=RIGHT>$amt</TD></TR>\n";
  echo "</TABLE><BR>\n";
    
  echo "<INPUT TYPE=HIDDEN NAME=customerid VALUE='$customerid'>\n";
  echo "<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>\n";

  echo "<INPUT TYPE=SUBMIT VALUE='Update and Recalculate Total'>\n";
  echo "</FORM><BR>\n";

  echo "<FORM ACTION='./dspurchase.php' METHOD='GET'>\n";
  echo "<INPUT TYPE=HIDDEN NAME=confirmpurchase VALUE='yes'>\n";
  echo "<INPUT TYPE=HIDDEN NAME=customerid VALUE='$customerid'>\n";
  echo "<INPUT TYPE=HIDDEN NAME=storenum VALUE=$storenum>\n";
  for ($i=0; $i<count($item); $i++)
    {
    if (empty($drop) || !in_array($i, $drop))
      {
      echo "<INPUT NAME='item[]' TYPE='HIDDEN' VALUE='$item[$i]'>";
      echo "<INPUT NAME='quan[]' TYPE='HIDDEN' VALUE='$quan[$i]'>\n";
      }
    }      
  echo "<INPUT TYPE=SUBMIT VALUE='Purchase'>\n";
  }
else  // confirmpurchase=yes  => update ORDERS, ORDERLINES, INVENTORY and CUST_HIST table
  {
  if (!($link_id = pg_connect($connstr))) die(pg_last_error());
 
  echo "<H2>Purchase complete</H2>\n";
  echo "<TABLE border=2>";
  echo "<TR>";
  echo "<TH>Item</TH>";
  echo "<TH>Quantity</TH>";
  echo "<TH>Title</TH>";
  echo "<TH>Actor</TH>";
  echo "<TH>Price</TH>";
  echo "</TR>\n";

  for ($i=0; $i<count($item); $i++)
    {
    $j = $i + 1;
    $quan[$i] = max(1,$quan[$i]);
    $purchase_query = "select PROD_ID, TITLE, ACTOR, PRICE from PRODUCTS$storenum where PROD_ID=$item[$i]";
    $purchase_result = pg_query($link_id,$purchase_query);
    $purchase_result_row = pg_fetch_row($purchase_result);
    pg_free_result($purchase_result);
    echo " <TR>";
    echo "<TD ALIGN=CENTER>$j</TD>";
    echo "<INPUT NAME='item[]' TYPE=HIDDEN VALUE='$purchase_result_row[0]'>";
    echo "<TD><INPUT NAME='quan[]' TYPE=TEXT SIZE=10 VALUE=$quan[$i]></TD>";
    echo "<TD>$purchase_result_row[1]</TD>";
    echo "<TD>$purchase_result_row[2]</TD>";
    $amt = sprintf("$%.2f", $purchase_result_row[3]);
    echo "<TD ALIGN=RIGHT>$amt</TD>";
    echo "</TR>\n";
    $netamount = $netamount + $quan[$i]*$purchase_result_row[3];
    }

  $taxpct = 8.25;
  $taxamount = $netamount * $taxpct/100.0;
  $totalamount = $taxamount + $netamount;
  $netamount_fmt = sprintf("%.2f", $netamount);
  echo "<TR><TD></TD><TD></TD><TD></TD><TD>Subtotal</TD><TD ALIGN=RIGHT>$" . $netamount_fmt . "</TD></TR>\n";
  $taxamount_fmt = sprintf("%.2f", $taxamount);
  echo "<TR><TD></TD><TD></TD><TD></TD><TD>Tax ($taxpct%)</TD><TD ALIGN=RIGHT>$" . $taxamount_fmt . "</TD></TR>\n";
  $totalamount_fmt = sprintf("%.2f", $totalamount);
  echo "<TR><TD></TD><TD></TD><TD></TD><TD>Total</TD><TD ALIGN=RIGHT>$" . $totalamount_fmt . "</TD></TR>\n";
  echo "</TABLE><BR>\n";

  date_default_timezone_set('America/Los_Angeles');
  $currentdate = date("Y-m-d");
  
  $num_items = count($item);
  
  // insert zeros for values not used
  
  for ($i=$num_items; $i<10; $i++)
    {
		$item[$i] = 0;
		$quan[$i] = 0;
	}

  // Call Purchase stored procedure / function
  
  $purchase_query = "SELECT * from purchase$storenum ($customerid,$num_items,$netamount_fmt,$taxamount_fmt,$totalamount_fmt," .
					"$item[0], $quan[0], $item[1], $quan[1], $item[2], $quan[2], $item[3], $quan[3], $item[4], $quan[4], " .
					"$item[5], $quan[5], $item[6], $quan[6], $item[7], $quan[7], $item[8], $quan[8], $item[9], $quan[9] );";
// echo " $purchase_query \n";
  $purchase_result = pg_query($link_id,$purchase_query);
  $row = pg_fetch_row($purchase_result);
  $orderid = $row[0];

  // check $orderid and handle error if = 0
  

    if ($orderid == 0 )  // purchase transaction failed
	  {
		echo "Call to Purchase function failed due to Insufficient stock or other issue:  query= $purchase_query\n";
	  }
    else  // purchase was successful
      {
      // To Do: verify credit card purchase against a second database
      $cctypes = array("MasterCard", "Visa", "Discover", "Amex", "Dell Preferred");

      $cc_query = "select CREDITCARDTYPE, CREDITCARD, CREDITCARDEXPIRATION from CUSTOMERS$storenum where CUSTOMERID=$customerid";
      $cc_result = pg_query($link_id,$cc_query);
      $cc_result_row = pg_fetch_row($cc_result);
      pg_free_result($cc_result);
      echo "<H3>$" . $totalamount_fmt . " charged to credit card $cc_result_row[1] " .
        "(" .  $cctypes[$cc_result_row[0]-1] . "), expiration $cc_result_row[2]</H3><BR>\n";
      echo "<H2>Order Completed Successfully --- ORDER NUMBER:  $orderid</H2><BR>\n";
      }
    
  } 

ds_html_footer();
pg_close($link_id);
?>
