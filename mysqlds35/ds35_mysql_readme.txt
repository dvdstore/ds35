ds35_mysql_readme.txt

DVDStore 3.5 (and the earlier version 2.1)  allows to create any custom size database. 

User must use perl script InstallDVDStore.pl in the ds35/ directory to create database of any size. 
The size given to InstallDVDStore.pl is for the size of the store.  If creating a DVD Store 3.5
instance with mulitple stores, each store will be the size specified.  Meaning that total size will 
be aproximately size X number of stores.  For example: if you specif a size of 4GB in InstallDVDStore.pl
and then create an instance with 5 stores, the total size will be aproximately 20GB ( 4GB x 5 stores).

To know more 
about how to use perl scripts and general instructions on DVDStore 3,
please go through document /ds35/ds35_Documentation.txt

In order to run the perl scripts on a windows system a perl utility of some sort is required. (Instructions for installing perl utility over windows
is included in document /ds35/ds35_Documentation.txt under prerequisites section)

--------------------------------------------------------------------------------------------------------------------

Instructions for building and loading the MySQL implementation of the DVD Store Version 3.5 (DS3) database

DS3 comes in 3 standard store sizes (but any size can be specified):

Database    Size     Customers             Orders   Products
Small      10 MB        20,000        1,000/month     10,000
Medium      1 GB     2,000,000      100,000/month    100,000
Large     100 GB   200,000,000   10,000,000/month  1,000,000

Directories
-----------
./ds35/mysqlds35
./ds35/mysqlds35/build
./ds35/mysqlds35/load
./ds35/mysqlds35/load/cust
./ds35/mysqlds35/load/orders
./ds35/mysqlds35/load/prod
./ds35/mysqlds35/load/reviews
./ds35/mysqlds35/load/membership
./ds35/mysqlds35/web
./ds35/mysqlds35/web/php5

The ./ds35/mysqlds35 directory contains two driver programs:
ds3mysqldriver.exe      (ftp in binary to a Windows machine)
ds3mysqldriver_mono.exe (run under Mono on Linux)
To see the syntax run program with no arguments on a command line.
To compile use ds3mysqlfns.cs with ./ds3/drivers/ds3xdriver.cs (see
that file's header)

The ./ds35/mysqlds35/build directory contains MySQL scripts to create the DS3
schema, indexes and stored procedures, as well as scripts to restore the
database to its initial state after a run.

The ./ds35/mysqlds35/load directories contain MySQL load scripts to load the data
from the datafiles under ./ds3/data_files. You will need to modify the scripts
if the data is elsewhere.
 
The ./ds35/mysqlds35/web directories contain a PHP application to drive DS3

The build and load of the Small DS3 database may be accomplished with the
shell script, mysqlds35_create_all.sh, in ./ds35/mysqlds35:

On MySQL machine:

Add user web with default home directory (/home/web); set password
    - As root: useradd web; passwd web
  - Fix permissions on /home directories
    - As root: chmod 755 /home/web;

1) Install MySQL
2) download ds35.tar.gz from github.com/dvdstore/ds35
3) untar or unzip on system
4) cd ./ds35/mysqlds35
5) sh mysqlds35_create_all.sh <target hostname or IP> <Number of Stores>

# mysqlds35_create_all.sh
# Syntax to run - perl mysqlds35_create_all.pl <mysql_target> <number_of_stores>
# start in ./ds35/mysqlds35
cd build
perl mysqlds35_perl_create_db_tables_multi.pl %1 %2
perl mysqlds35_perl_create_indexes_multi.pl %1 %2
perl mysqlds35_perl_create_sp_multi.pl %1 %2
cd ../load/
perl ds35_create_mysql_multistore_load_files.pl %1 %2
perl ds35_execute_mysql_multistore_load.pl %1 %2
cd ..


my.cnf.example is the MySQL configuration file used in our testing (copy to /etc/my.cnf)
my.cnf.example.diff shows the differences between my.cnf.example and /usr/share/mysql/my-large.cnf

monitor_load.txt describes how to monitor the load of InnoDB tables using showinnodb.sql

Most of the directories contain readme's with further instructions

<davejaffe7@gmail.com> and <tmuirhead@vmware.com>  2/10/20
