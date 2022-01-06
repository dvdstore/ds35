ds35_pgsql_readme.txt


DVDStore 3.5 allows you to create any custom size database. 

User can use perl scripts in DVDStore 3.5 to create database of any size. To know more 
about how to use perl scripts and general instructions on DVDStore 3.5,
please go through document /ds35/ds35_Documentation.txt

In order to run the perl scripts on a windows system a perl utility of some sort is required. (Instructions for installing perl utility over windows
is included in document /ds35/ds35_Documentation.txt under prerequisites section)

--------------------------------------------------------------------------------------------------------------------

Instructions for building and loading the PostgreSQL implementation of the DVD Store Version 3 (DS3) database

DS3 can be created in any size by has 3 "standard" sizes:

Database    Size     Customers             Orders   Products
Small      10 MB        20,000        1,000/month     10,000
Medium      1 GB     2,000,000      100,000/month    100,000
Large     100 GB   200,000,000   10,000,000/month  1,000,000

Directories
-----------
./ds35/pgsqlds35
./ds35/pgsqlds35/dotnet
./ds35/pgsqlds35/build
./ds35/pgsqlds35/load
./ds35/pgsqlds35/load/cust
./ds35/pgsqlds35/load/orders
./ds35/pgsqlds35/load/prod
./ds35/pgsqlds35/web
./ds35/pgsqlds35/web/jsp
./ds35/pgsqlds35/web/php

The ./ds35/pgsqlds35 directory contains the windows x64 based driver program:
ds35pgsqldriver.exe      (ftp in binary to a Windows machine)

To see the syntax run program with no arguments on a command line.
To re-compile use Microsoft .net 5.x dotnet publish command with ds35pgsqlfns.cs with and ./ds35/drivers/ds35xdriver.cs
(see ./ds35/pgsqlds35/dotnet for more details)

The ./ds35/pgsqlds35/build directory contains PostgreSQL scripts to create the DS35
schema, indexes and stored procedures, as well as scripts to restore the
database to its initial state after a run.

The ./ds35/pgsqlds35/load directories contain PostgreSQL load scripts to load the data
from the datafiles under ./ds35/data_files. You will need to modify the scripts
if the data is elsewhere.
 
The ./ds35/pgsqlds35/web directories contain PHP and JSP applications to drive DS35

The build and load of the Small  database may be accomplished with the
shell script, pgsqlds35_create_all.sh, in ./ds35/pgsqlds35:

On PostgreSQL machine:

Install PostgresSQL 13.x or later, for more details please reference postgres-setup.txt.

By default the data_files that are included with the ds35 download are for the small DVDStore database.  
To create custom size database you can also use the Install_DVDStore.pl script in the ds35/ directory to create 
the load script and data files for any size database. When you run Install_DVDStore.pl it will ask you a series of
questions that allow you to specify the size and database type.  It then will produce the needed sripts and data files.

postgresql.conf.example is the PostgreSQL configuration file used in our testing (append to $PGDATA/postgresql.conf)

In order to enable remote systems to be able to access the PostgreSQL database it is necessary to make two changes.
These two changes will enable completely open access, if you need more a restrictive policy these settings would be different:
1) In postgres.conf - listen_Addresses = '*'
2) In pg_hba.conf add a line:
host	all	all	0.0.0.0/0	trust

Driver Program
--------------

The ds35pgsqldriver.exe is the Postgresql implementation of the DS35 driver. It is 
based on ds35pgsqlfns.cs (in this directory) and ds35xdriver.cs (in ds35/drivers). It is a C# .Net program that uses the 
Microsoft .Net runtime which can be run on most platforms.  ds35pgsqldriver.exe is binary built for windows x86_64. 
Other platorms can be built.  Please see the readme in the /ds35/ds35pgslq/dotnet diretory.  This direct driver that 
generates load against the database that simulates users logging on, browsing, and purchasing items from the 
DVDStore website. 

The included windows binary is standalone and can be run without anything additional. 

If you want to build for another platform like Linux or MacOS, you will need to install .net 5.0 and then do the
following from the /ds35/pgsqlds35/dotnet directory:
dotnet new console
dotnet add package Npgsql --version 5.0.4
dotnet run
(or dotnet publish to build a binary - see notes in pgsqlds35/dotnet directory for full command details)

You can run ds35pgsqldriver.exe --help to get a full listing of parameters, a description of each, and their default values.

In addition to this direct driver there is ds35webdriver (located the ds35/drivers) that can be used to drive load though
the PHP version of the DVDStore webtier that has been implemented to use the Postgresql version of the DVDStore
datbase.  Please see the pgsqlds35/web directory for more info on the webtier version.

<tmuirhead@vmware.com>  1/05/22
