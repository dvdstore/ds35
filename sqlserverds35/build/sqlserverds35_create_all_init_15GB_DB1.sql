
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
    FILENAME = 'f:\dbfiles1\ds.mdf'
    ),
  FILEGROUP DS_MISC_FG
    (
    NAME = 'ds_misc', 
    FILENAME = 'f:\dbfiles1\ds_misc.ndf',
    SIZE = 1500MB
    ),
  FILEGROUP DS_CUST_FG
    (
    NAME = 'cust1', 
    FILENAME = 'f:\dbfiles1\cust1.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust2', 
    FILENAME = 'f:\dbfiles1\cust2.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'cust3', 
    FILENAME = 'f:\dbfiles1\cust3.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust4', 
    FILENAME = 'f:\dbfiles1\cust4.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'cust5', 
    FILENAME = 'g:\dbfiles1\cust5.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust6', 
    FILENAME = 'g:\dbfiles1\cust6.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'cust7', 
    FILENAME = 'g:\dbfiles1\cust7.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust8', 
    FILENAME = 'g:\dbfiles1\cust8.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'cust9', 
    FILENAME = 'h:\dbfiles1\cust9.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust10', 
    FILENAME = 'h:\dbfiles1\cust10.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'cust11', 
    FILENAME = 'h:\dbfiles1\cust11.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'cust12', 
    FILENAME = 'h:\dbfiles1\cust12.ndf',
    SIZE = 4500MB
    ),
  FILEGROUP DS_ORDERS_FG
    (
    NAME = 'orders1', 
    FILENAME = 'f:\dbfiles1\orders1.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders2', 
    FILENAME = 'f:\dbfiles1\orders2.ndf',
    SIZE = 2800MB
    ),
	(
    NAME = 'orders3', 
    FILENAME = 'f:\dbfiles1\orders3.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders4', 
    FILENAME = 'f:\dbfiles1\orders4.ndf',
    SIZE = 2800MB
    ),
	(
    NAME = 'orders5', 
    FILENAME = 'g:\dbfiles1\orders5.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders6', 
    FILENAME = 'g:\dbfiles1\orders6.ndf',
    SIZE = 2800MB
    ),
	(
    NAME = 'orders7', 
    FILENAME = 'g:\dbfiles1\orders7.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders8', 
    FILENAME = 'g:\dbfiles1\orders8.ndf',
    SIZE = 2800MB
    ),
	(
    NAME = 'orders9', 
    FILENAME = 'h:\dbfiles1\orders9.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders10', 
    FILENAME = 'h:\dbfiles1\orders10.ndf',
    SIZE = 2800MB
    ),
	(
    NAME = 'orders11', 
    FILENAME = 'h:\dbfiles1\orders11.ndf',
    SIZE = 2800MB
    ),
    (
    NAME = 'orders12', 
    FILENAME = 'h:\dbfiles1\orders12.ndf',
    SIZE = 2800MB
    ),
  FILEGROUP DS_IND_FG
    (
    NAME = 'ind1', 
    FILENAME = 'f:\dbfiles1\ind1.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind2', 
    FILENAME = 'f:\dbfiles1\ind2.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'ind3', 
    FILENAME = 'f:\dbfiles1\ind3.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind4', 
    FILENAME = 'f:\dbfiles1\ind4.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'ind5', 
    FILENAME = 'g:\dbfiles1\ind5.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind6', 
    FILENAME = 'g:\dbfiles1\ind6.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'ind7', 
    FILENAME = 'g:\dbfiles1\ind7.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind8', 
    FILENAME = 'g:\dbfiles1\ind8.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'ind9', 
    FILENAME = 'h:\dbfiles1\ind9.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind10', 
    FILENAME = 'h:\dbfiles1\ind10.ndf',
    SIZE = 4500MB
    ),
	(
    NAME = 'ind11', 
    FILENAME = 'h:\dbfiles1\ind11.ndf',
    SIZE = 4500MB
    ),
    (
    NAME = 'ind12', 
    FILENAME = 'h:\dbfiles1\ind12.ndf',
    SIZE = 4500MB
    ),
  FILEGROUP DS_MEMBER_FG
    (
    NAME = 'member1',
    FILENAME = 'f:\dbfiles1\member1.ndf',
    SIZE = 150MB
    ),
    (
    NAME = 'member2', 
    FILENAME = 'f:\dbfiles1\member2.ndf',
    SIZE = 150MB
    ),
	(
    NAME = 'member3',
    FILENAME = 'g:\dbfiles1\member3.ndf',
    SIZE = 150MB
    ),
    (
    NAME = 'member4', 
    FILENAME = 'g:\dbfiles1\member4.ndf',
    SIZE = 150MB
    ),
	(
    NAME = 'member5',
    FILENAME = 'h:\dbfiles1\member5.ndf',
    SIZE = 150MB
    ),
    (
    NAME = 'member6', 
    FILENAME = 'h:\dbfiles1\member6.ndf',
    SIZE = 150MB
    ),
FILEGROUP DS_REVIEW_FG
    (
    NAME = 'review1',
    FILENAME = 'f:\dbfiles1\review1.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review2', 
    FILENAME = 'f:\dbfiles1\review2.ndf',
    SIZE = 2300MB
    ),
	(
    NAME = 'review3',
    FILENAME = 'f:\dbfiles1\review3.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review4', 
    FILENAME = 'f:\dbfiles1\review4.ndf',
    SIZE = 2300MB
    ),
	(
    NAME = 'review5',
    FILENAME = 'g:\dbfiles1\review5.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review6', 
    FILENAME = 'g:\dbfiles1\review6.ndf',
    SIZE = 2300MB
    ),
	(
    NAME = 'review7',
    FILENAME = 'g:\dbfiles1\review7.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review8', 
    FILENAME = 'g:\dbfiles1\review8.ndf',
    SIZE = 2300MB
    ),
	(
    NAME = 'review9',
    FILENAME = 'h:\dbfiles1\review9.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review10', 
    FILENAME = 'h:\dbfiles1\review10.ndf',
    SIZE = 2300MB
    ),
	(
    NAME = 'review11',
    FILENAME = 'h:\dbfiles1\review11.ndf',
    SIZE = 2300MB
    ),
    (
    NAME = 'review12', 
    FILENAME = 'h:\dbfiles1\review12.ndf',
    SIZE = 2300MB
    ),
FILEGROUP DS_FULLTEXT_FG
	(
	NAME = 'fulltext1',
	FILENAME = 'f:\dbfiles1\fulltext1.ndf',
	SIZE = 150MB
	),
	(
	NAME = 'fulltext2',
	FILENAME = 'f:\dbfiles1\fulltext2.ndf',
	SIZE = 150MB
	),
	(
	NAME = 'fulltext3',
	FILENAME = 'g:\dbfiles1\fulltext3.ndf',
	SIZE = 150MB
	),
	(
	NAME = 'fulltext4',
	FILENAME = 'g:\dbfiles1\fulltext4.ndf',
	SIZE = 150MB
	),
	(
	NAME = 'fulltext5',
	FILENAME = 'h:\dbfiles1\fulltext5.ndf',
	SIZE = 150MB
	),
	(
	NAME = 'fulltext6',
	FILENAME = 'h:\dbfiles1\fulltext6.ndf',
	SIZE = 150MB
	)
  LOG ON
    (
    NAME = 'ds_log', 
    FILENAME = 'e:\dbfiles1\ds_log.ldf',
    SIZE = 20000MB
    )
GO


