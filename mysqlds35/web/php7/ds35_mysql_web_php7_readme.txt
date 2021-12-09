ds35_mysql_web_php5_readme.txt

php7 interface to the MySQL DVD Store database
Requires php 7.4/MySQL 8
Files:

dscommon.inc
dspurchase.php
dsnewcustomer.php      
dsnewmember.php
dsbrowse.php
dsgetreviews.php
dsbrowsreviews.php
dsnewreview.php
dsnewhelpfulness.php
dslogin.php

The driver programs expect these files in a virtual directory "ds3".
In your web server you either need to create a virtual directory that points
to this directory or copy these files to the appropriate directory (eg /var/www/html/ds3)

<tmuirhead@vmware.com>  12/8/21
