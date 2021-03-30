

ds35_sqlserver_readme.txt


DVDStore 3.5 allows user to create any custom size database. 

User must use perl scripts in DVDStore 3.5 to create database of any size. To know more 
about how to use perl scripts and general instructions on DVDStore 3.5,
please go through document /ds35/ds35_Documentation.txt

The InstallDVDStore.pl script will generate a set of scripts that will create, load, index, and gather stats.
It is hightly recommended to use the script that is created by InstallDVDStore to create the DS35 database. 

In order to run the perl scripts on a windows system a perl utility of some sort is required. (Instructions for installing perl utility over windows
is included in document /ds35/ds35_Documentation.txt under prerequisites section)

In addition it is necessary to have SQL Server Command line tools installed on the system.  If you are building the database locally on the server,
then these tools are probably already installed.  If not you will need to get the latest version of SQL Server Command line tools that includes
sqlcmd.exe and bcp.exe for the scripts to be able to execute the SQL commands and bulk load the data.

-------------------------------------------------------------------------------------------------------------------------------------


Instructions for building and loading the SQL Server implementation of the DVD Store Version 3.5 (DS35) database

DS3.5 has 3 standard sizes:

Database    Size     Customers             Orders   Products
Small      10 MB        20,000        1,000/month     10,000
Medium      1 GB     2,000,000      100,000/month    100,000
Large     100 GB   200,000,000   10,000,000/month  1,000,000

Directories
-----------
./ds35/sqlserverds35
./ds35/sqlserverds35/build
./ds35/sqlserverds35/load
./ds35/sqlserverds35/load/cust
./ds35/sqlserverds35/load/orders
./ds35/sqlserverds35/load/prod
./ds35/sqlserverds35/load/membership
./ds35/sqlserverds35/load/reviews

The ./ds35/sqlserverds35 directory contains a driver program:
ds35sqlserverdriver.exe      
To see the syntax run it with no arguments on a command line.
To compile use ds3sqlserverfns.cs with ./ds35/data_files/drivers/ds35xdriver.cs (see
that file's header).

The ./ds35/sqlserverds35/build directory contains SQL Server scripts to create the DS35
schema, indexes and stored procedures, as well as scripts to restore the
database to its initial state after a run.

The ./ds35/sqlserverds35/load directories contain SQL Server load scripts to load the data
from the datafiles under ./ds35/data_files. You will need to modify the scripts
if the data is elsewhere. (Assumes data is in c:\ds3\data_files in Windows)
 

Instructions for building the small (10MB) DS SQL Server database 
(assumes create files and data under c: and SQL Server files under c:\sql\dbfiles).
Add sa password after -P if not blank.

On SQL Server machine:

 1) Install SQL Server (be sure full-text search is enabled)
 2) unzip ds3-master.zip to c:
 3) copy \ds35-master\ds35 to \ds35 
 4) Create directory c:\sql\dbfiles 
 
 5) in c:\ds35: perl InstallDVDStore.pl
	size of DB: 10
	metric of size: MB
	type of DB: MSSQL
	database OS: windows
	path: c:\sql\dbfiles\
	
 6) in c:\ds35\sqlserverds35:			sqlserverds35_create_All_concurrent_10MB.bat

Most of the directories contain readme's with further instructions

<davejaffe7@gmail.com> and <tmuirhead@vmware.com>  6/4/19



