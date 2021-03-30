
-- sqlserverds3_create_all_generic_template.sql: 
-- DVD Store Database Version 3 Build, Load and Create Index Script - SQL Server version - Small DB
-- Copyright (C) 2007 Dell, Inc. <davejaffe7@gmail.com> and <tmuirhead@vmware.com>
-- Last updated 12/05/15


-- sqlserverds3_create_db.sql

IF EXISTS (SELECT * FROM SYSDATABASES WHERE NAME='DS3')
DROP DATABASE DS3
GO

CREATE DATABASE DS3 ON 
  PRIMARY
    (
    NAME = 'primary', 
    FILENAME = '/var/opt/mssql/data/dbfiles/ds.mdf'
    ),
  FILEGROUP DS_MISC_FG
    (
    NAME = 'ds_misc', 
    FILENAME = '/var/opt/mssql/data/dbfiles/ds_misc.ndf',
    SIZE = 250MB
    ),
  FILEGROUP DS_CUST_FG
    (
    NAME = 'cust1', 
    FILENAME = '/var/opt/mssql/data/dbfiles/cust1.ndf',
    SIZE = 2000MB
    ),
    (
    NAME = 'cust2', 
    FILENAME = '/var/opt/mssql/data/dbfiles/cust2.ndf',
    SIZE = 2000MB
    ),
	(
    NAME = 'cust3', 
    FILENAME = '/var/opt/mssql/data/dbfiles/cust3.ndf',
    SIZE = 2000MB
    ),
    (
    NAME = 'cust4', 
    FILENAME = '/var/opt/mssql/data/dbfiles/cust4.ndf',
    SIZE = 2000MB
    ),
  FILEGROUP DS_ORDERS_FG
    (
    NAME = 'orders1', 
    FILENAME = '/var/opt/mssql/data/dbfiles/orders1.ndf',
    SIZE = 1400MB
    ),
    (
    NAME = 'orders2', 
    FILENAME = '/var/opt/mssql/data/dbfiles/orders2.ndf',
    SIZE = 1400MB
    ),
	(
    NAME = 'orders3', 
    FILENAME = '/var/opt/mssql/data/dbfiles/orders3.ndf',
    SIZE = 1400MB
    ),
    (
    NAME = 'orders4', 
    FILENAME = '/var/opt/mssql/data/dbfiles/orders4.ndf',
    SIZE = 1400MB
    ),
  FILEGROUP DS_IND_FG
    (
    NAME = 'ind1', 
    FILENAME = '/var/opt/mssql/data/dbfiles/ind1.ndf',
    SIZE = 1500MB
    ),
    (
    NAME = 'ind2', 
    FILENAME = '/var/opt/mssql/data/dbfiles/ind2.ndf',
    SIZE = 1500MB
    ),
	(
    NAME = 'ind3', 
    FILENAME = '/var/opt/mssql/data/dbfiles/ind3.ndf',
    SIZE = 1500MB
    ),
    (
    NAME = 'ind4', 
    FILENAME = '/var/opt/mssql/data/dbfiles/ind4.ndf',
    SIZE = 1500MB
    ),
  FILEGROUP DS_MEMBER_FG
    (
    NAME = 'member1',
    FILENAME = '/var/opt/mssql/data/dbfiles/member1.ndf',
    SIZE = 100MB
    ),
    (
    NAME = 'member2', 
    FILENAME = '/var/opt/mssql/data/dbfiles/member2.ndf',
    SIZE = 100MB
    ),
FILEGROUP DS_REVIEW_FG
    (
    NAME = 'review1',
    FILENAME = '/var/opt/mssql/data/dbfiles/review1.ndf',
    SIZE = 1000MB
    ),
    (
    NAME = 'review2', 
    FILENAME = '/var/opt/mssql/data/dbfiles/review2.ndf',
    SIZE = 1000MB
    ),
	(
    NAME = 'review3',
    FILENAME = '/var/opt/mssql/data/dbfiles/review3.ndf',
    SIZE = 1000MB
    ),
    (
    NAME = 'review4', 
    FILENAME = '/var/opt/mssql/data/dbfiles/review4.ndf',
    SIZE = 1000MB
    ),
FILEGROUP DS_FULLTEXT_FG
	(
	NAME = 'fulltext1',
	FILENAME = '/var/opt/mssql/data/dbfiles/fulltext1.ndf',
	SIZE = 100MB
	),
	(
	NAME = 'fulltext2',
	FILENAME = '/var/opt/mssql/data/dbfiles/fulltext2.ndf',
	SIZE = 100MB
	)
  LOG ON
    (
    NAME = 'ds_log', 
    FILENAME = '/var/opt/log/ds_log.ldf',
    SIZE = 7000MB
    )
GO


