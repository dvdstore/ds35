ds35_pgsql_build_readme.txt

Instructions for building DVD Store Version 3.5 (DS35) database

It is recommended to run pgsqlds35_create_all in the ds35/pgsqlds35 directory.  That script uses the
scripts in this build directory.  Additionally, the Install_DVDStore.pl script will place additional
versions of the cleanup script in this directory that are specific to the size.

The pgsqlds35_cleanup_XXXXXXX scripts are run to get the database back to the state it was after initial 
creation.  It does this by removing all of the new customers, new orders, new order history, and resetting
the inventory table to it's initial state.  

<jshah@vmware.com> and <tmuirhead@vmware.com>  11/30/21

