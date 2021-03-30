
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
    FILENAME = 'L:\dbfiles5\ds.mdf'
    ),
  FILEGROUP DS_MISC_FG
    (
    NAME = 'ds_misc', 
    FILENAME = 'L:\dbfiles5\ds_misc.ndf',
    SIZE = 500MB
    ),
  FILEGROUP DS_CUST_FG
    (
    NAME = 'cust1', 
    FILENAME = 'L:\dbfiles5\cust1.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust2', 
    FILENAME = 'L:\dbfiles5\cust2.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'cust3', 
    FILENAME = 'L:\dbfiles5\cust3.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust4', 
    FILENAME = 'L:\dbfiles5\cust4.ndf',
    SIZE = 4500MB
    ),
  FILEGROUP DS_ORDERS_FG
    (
    NAME = 'orders1', 
    FILENAME = 'L:\dbfiles5\orders1.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders2', 
    FILENAME = 'L:\dbfiles5\orders2.ndf',
    SIZE = 2800MB
    ),
	(
    NAME = 'orders3', 
    FILENAME = 'L:\dbfiles5\orders3.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders4', 
    FILENAME = 'L:\dbfiles5\orders4.ndf',
    SIZE = 2800MB
    ),
  FILEGROUP DS_IND_FG
    (
    NAME = 'ind1', 
    FILENAME = 'L:\dbfiles5\ind1.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind2', 
    FILENAME = 'L:\dbfiles5\ind2.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'ind3', 
    FILENAME = 'L:\dbfiles5\ind3.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind4', 
    FILENAME = 'L:\dbfiles5\ind4.ndf',
    SIZE = 4500MB
    ),
  FILEGROUP DS_MEMBER_FG
    (
    NAME = 'member1',
    FILENAME = 'L:\dbfiles5\member1.ndf',
    SIZE = 150MB
    ),
    (
    NAME = 'member2', 
    FILENAME = 'L:\dbfiles5\member2.ndf',
    SIZE = 150MB
    ),
FILEGROUP DS_REVIEW_FG
    (
    NAME = 'review1',
    FILENAME = 'L:\dbfiles5\review1.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review2', 
    FILENAME = 'L:\dbfiles5\review2.ndf',
    SIZE = 2300MB
    ),
	(
    NAME = 'review3',
    FILENAME = 'L:\dbfiles5\review3.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review4', 
    FILENAME = 'L:\dbfiles5\review4.ndf',
    SIZE = 2300MB
    ),
FILEGROUP DS_FULLTEXT_FG
	(
	NAME = 'fulltext1',
	FILENAME = 'L:\dbfiles5\fulltext1.ndf',
	SIZE = 150MB
	),
	(
	NAME = 'fulltext2',
	FILENAME = 'L:\dbfiles5\fulltext2.ndf',
	SIZE = 150MB
	)
  LOG ON
    (
    NAME = 'ds_log', 
    FILENAME = 'k:\dbfiles5\ds_log.ldf',
    SIZE = 10000MB
    )
GO


