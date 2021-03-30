
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
    FILENAME = 'c:\dbfilesds.mdf'
    ),
  FILEGROUP DS_MISC_FG
    (
    NAME = 'ds_misc', 
    FILENAME = 'c:\dbfilesds_misc.ndf',
    SIZE = 200MB
    ),
  FILEGROUP DS_CUST_FG
    (
    NAME = 'cust1', 
    FILENAME = 'c:\dbfilescust1.ndf',
    SIZE = 600MB
    ),
    (
    NAME = 'cust2', 
    FILENAME = 'c:\dbfilescust2.ndf',
    SIZE = 600MB
    ),
  FILEGROUP DS_ORDERS_FG
    (
    NAME = 'orders1', 
    FILENAME = 'c:\dbfilesorders1.ndf',
    SIZE = 300MB
    ),
    (
    NAME = 'orders2', 
    FILENAME = 'c:\dbfilesorders2.ndf',
    SIZE = 300MB
    ),
  FILEGROUP DS_IND_FG
    (
    NAME = 'ind1', 
    FILENAME = 'c:\dbfilesind1.ndf',
    SIZE = 150MB
    ),
    (
    NAME = 'ind2', 
    FILENAME = 'c:\dbfilesind2.ndf',
    SIZE = 150MB
    ),
  FILEGROUP DS_MEMBER_FG
    (
    NAME = 'member1',
    FILENAME = 'c:\dbfilesmember1.ndf',
    SIZE = 100MB
    ),
    (
    NAME = 'member2', 
    FILENAME = 'c:\dbfilesmember2.ndf',
    SIZE = 100MB
    ),
FILEGROUP DS_REVIEW_FG
    (
    NAME = 'review1',
    FILENAME = 'c:\dbfilesreview1.ndf',
    SIZE = 300MB
    ),
    (
    NAME = 'review2', 
    FILENAME = 'c:\dbfilesreview2.ndf',
    SIZE = 300MB
    ),
FILEGROUP DS_FULLTEXT_FG
	(
	NAME = 'fulltext1',
	FILENAME = 'c:\dbfilesfulltext1.ndf',
	SIZE = 100MB
	)
  LOG ON
    (
    NAME = 'ds_log', 
    FILENAME = 'c:\dbfilesds_log.ldf',
    SIZE = 100MB
    )
GO


