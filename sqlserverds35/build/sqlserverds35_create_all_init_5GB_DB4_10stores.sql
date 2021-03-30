
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
    FILENAME = 'h:\dbfiles4\ds.mdf'
    ),
  FILEGROUP DS_MISC_FG
    (
    NAME = 'ds_misc', 
    FILENAME = 'h:\dbfiles4\ds_misc.ndf',
    SIZE = 1000MB
    ),
  FILEGROUP DS_CUST_FG
    (
    NAME = 'cust1', 
    FILENAME = 'h:\dbfiles4\cust1.ndf',
    SIZE = 12000MB
    ),
    (
    NAME = 'cust2', 
    FILENAME = 'h:\dbfiles4\cust2.ndf',
    SIZE = 12000MB
    ),
	(
    NAME = 'cust3', 
    FILENAME = 'h:\dbfiles4\cust3.ndf',
    SIZE = 12000MB
    ),
    (
    NAME = 'cust4', 
    FILENAME = 'h:\dbfiles4\cust4.ndf',
    SIZE = 12000MB
    ),
  FILEGROUP DS_ORDERS_FG
    (
    NAME = 'orders1', 
    FILENAME = 'h:\dbfiles4\orders1.ndf',
    SIZE = 6000MB
    ),
    (
    NAME = 'orders2', 
    FILENAME = 'h:\dbfiles4\orders2.ndf',
    SIZE = 6000MB
    ),
	(
    NAME = 'orders3', 
    FILENAME = 'h:\dbfiles4\orders3.ndf',
    SIZE = 6000MB
    ),
    (
    NAME = 'orders4', 
    FILENAME = 'h:\dbfiles4\orders4.ndf',
    SIZE = 6000MB
    ),
  FILEGROUP DS_IND_FG
    (
    NAME = 'ind1', 
    FILENAME = 'h:\dbfiles4\ind1.ndf',
    SIZE = 9000MB
    ),
    (
    NAME = 'ind2', 
    FILENAME = 'h:\dbfiles4\ind2.ndf',
    SIZE = 9000MB
    ),
	(
    NAME = 'ind3', 
    FILENAME = 'h:\dbfiles4\ind3.ndf',
    SIZE = 9000MB
    ),
    (
    NAME = 'ind4', 
    FILENAME = 'h:\dbfiles4\ind4.ndf',
    SIZE = 9000MB
    ),
  FILEGROUP DS_MEMBER_FG
    (
    NAME = 'member1',
    FILENAME = 'h:\dbfiles4\member1.ndf',
    SIZE = 300MB
    ),
    (
    NAME = 'member2', 
    FILENAME = 'h:\dbfiles4\member2.ndf',
    SIZE = 300MB
    ),
FILEGROUP DS_REVIEW_FG
    (
    NAME = 'review1',
    FILENAME = 'h:\dbfiles4\review1.ndf',
    SIZE = 5000MB
    ),
    (
    NAME = 'review2', 
    FILENAME = 'h:\dbfiles4\review2.ndf',
    SIZE = 5000MB
    ),
	(
    NAME = 'review3',
    FILENAME = 'h:\dbfiles4\review3.ndf',
    SIZE = 5000MB
    ),
    (
    NAME = 'review4', 
    FILENAME = 'h:\dbfiles4\review4.ndf',
    SIZE = 5000MB
    ),
FILEGROUP DS_FULLTEXT_FG
	(
	NAME = 'fulltext1',
	FILENAME = 'h:\dbfiles4\fulltext1.ndf',
	SIZE = 300MB
	),
	(
	NAME = 'fulltext2',
	FILENAME = 'h:\dbfiles4\fulltext2.ndf',
	SIZE = 300MB
	)
  LOG ON
    (
    NAME = 'ds_log', 
    FILENAME = 'g:\dbfiles4\ds_log.ldf',
    SIZE = 10000MB
    )
GO


