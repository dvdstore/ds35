ds35_oracle_readme.txt

DVDStore 3.5 allows to create any custom size database. 

User must use perl scripts in DVDStore 3 to create database of any size. To know more 
about how to use perl scripts and general instructions on DVDStore 3,
please go through document /ds3/ds3.1_Documentation.txt

In order to run the perl scripts on a windows system a perl utility of some sort is required. 
(Instructions for installing perl utility over windowsis included in document 
/ds35/ds3.5_Documentation.txt under prerequisites section)

An Oracle client is also required to run the ds35oracledriver.exe program.  There are notes
at the end of this readme with details.

-------------------------------------------------------------------------------------------------------------------------------------

Instructions for building and loading the Oracle implementation of the DVD Store Version 3 (DS3) database

DS3 has 3 "standard" sizes:

Database    Size     Customers             Orders   Products
Small      10 MB        20,000        1,000/month     10,000
Medium      1 GB     2,000,000      100,000/month    100,000
Large     100 GB   200,000,000   10,000,000/month  1,000,000

Directories
-----------
./ds35/oracleds35
./ds35/oracleds35/build
./ds35/oracleds35/load
./ds35/oracleds35/load/cust
./ds35/oracleds35/load/orders
./ds35/oracleds35/load/prod
./ds35/oracleds35/load/membership
./ds35/oracleds35/load/reviews
./ds35/oracleds35/web
./ds35/oracleds35/web/jsp

The ./ds35/oracleds35/build directory contains Oracle scripts to create the DS3
schema, indexes and stored procedures, as well as scripts to restore the
database to its initial state after a run.

The ./ds35/oracleds35/load directories contain Oracle load scripts to load the data
from the datafiles under ./ds35/data_files. You will need to modify the scripts
if the data is elsewhere.
 
The ./ds35/oracleds35/web/jsp directory contains a Java Server Pages application to 
drive DS3.

The build and load of the Small DS3 database may be accomplished with the
shell script, oracleds3_create_all.sh, in ./ds3/oracleds3. For details see 
build/ds3_oracle_build_readme.txt
                                                                            
In order to run the sh scripts on a windows system a sh utility of some sort 
is required. 

A C# .NET driver program is available:
ds3oracledriver.exe      (ftp in binary to a Windows machine)
To see the syntax run program with no arguments on a command line.
To compile use ds35oraclefns.cs with ./ds3/drivers/ds35xdriver.cs (see that file's header)

ds35oracledriver.exe is now compiled with the 64b Oracle 19g Oracle Data Provider for .NET (ODP.NET)

In order to run the ds35oracledriver.exe you must have a registered Oracle.DataAccess.dll that is the same version as the one that was used when the driver was compiled.

The version of Oracle.DataAccess.dll used for the compile is the one included with Oracle Client 19c3 – WINDOWS.X64_193000_client_home.zip – from Oracle website.  Free Oracle ID required to download.

Download the Oracle 19c Client for Windows.

Unzip it.

Run the setup.exe to install all of the utilities – including Oracle NetMgr which will be needed to finish the setup of the driver for Oracle.

Open Command prompt.  Go to <unziplocation>\ODP.NET\bin\4

Register the Oracle.DataAccess.dll with the following command:
OraProvCfg.exe /action:gac /providerpath:Oracle.DataAccess.dll

You should now be able to run the included ds35oracledriver.exe.  If you get the following error: 

System.IO.FileNotFoundException: Could not load file or assembly 'Oracle.DataAccess

It means that your version is not the same and you will need to recompile the ds35oracledriver.exe by following the example in the header of ds35xdriver.cs for oracle.
I have included the command here as well.  You will need to get the path to your csc.exe (The csharp compiler for windows, and the path the Oracle.DataAccess.dll):
<path>csc /out:ds35oracledriver.exe    ds35xdriver.cs ds35oraclefns.cs    /d:USE_WIN32_TIMER /d:GEN_PERF_CTRS  /r:<path>Oracle.DataAccess.dll

		
Most of the directories contain readme's with further instructions

<davejaffe7@gmail.com> and <tmuirhead@vmware.com>  3/24/21
