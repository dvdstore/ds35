Instructions for building and driving DVD Store Version 3.5 (DS35)
database

The DVD Store Version 3.5 (DS3) is a complete online e-commerce test
application, with a backend database component, a web application
layer, and driver programs.  The goal in designing the database
component as well as the midtier application was to utilize many
advanced database features (transactions, stored procedures, triggers,
referential integity) while keeping the database easy to install and
understand. The DS3 workload may be used to test databases or as a
stress tool for any purpose.

The distribution will include code for SQL Server, Oracle, MySQL, and PostGres.
Included in the release are data generation programs, shell scripts to 
build data for 10MB, 1GB and 100 GB versions of the DVD Store, a perl
script to help generate any custom size database, database 
build scripts and stored procedure, PHP web pages, and a C# driver program.

The DS35 files are separated into database-independent data load files
under ./ds35/data_files and driver programs under ./ds35/drivers
and database-specific build scripts, loader programs, and driver
programs in directories
./ds35/mysqlds3
./ds35/oracleds3
./ds35/sqlserverds3
./ds35/pgsqlds3

To install:

Unzip download from github in the directory in which you want to install ds35.

Use perl to run the InstallDVDStore.pl script located in the main ds35 directory.
This will create the dataset to be loaded and a "Create_all" script specific
to the answers provided during the running of InstallDVDstore.pl.  Run the 
"create_all" script providing the host where the database software is already 
setup and the number of stores you wish to create.

More details are in the ds35_documentation.txt file.

The loader programs use relative addressing to reference the data
files. They will need to be changed if the data files are placed
elsewhere.

DS3 comes in 3 standard sizes:

Database    Size     Customers             Orders   Products
Small      10 MB        20,000        1,000/month     10,000
Medium      1 GB     2,000,000      100,000/month    100,000
Large     100 GB   200,000,000   10,000,000/month  1,000,000


Most of the directories contain readme's with further instructions

<davejaffe7@gmail.com> and <tmuirhead@vmware.com>  3/30/21
