
-- sqlserverds3_create_db_large4.sql: DVD Store Database Version 3 Build Script - SQL Server version
-- Copyright (C) 2007 Dell, Inc. <davejaffe7@gmail.com> and <tmuirhead@vmware.com>
-- Last updated 12/05/15

IF EXISTS (SELECT * FROM SYSDATABASES WHERE NAME='DS3')
DROP DATABASE DS3
GO

CREATE DATABASE DS3 ON 
  PRIMARY
    (
    NAME = 'primary', 
    FILENAME = 'G:\ds.mdf'
    ),
  FILEGROUP DS_MISC_FG
    (
    NAME = 'ds_misc', 
    FILENAME = 'H:\ds_misc.ndf',
    SIZE = 1GB
    ),
  FILEGROUP DS_CUST_FG
    (
    NAME = 'cust1', 
    FILENAME = 'G:\cust1.ndf',
    SIZE = 30GB
    ),
    (
    NAME = 'cust2', 
    FILENAME = 'H:\cust2.ndf',
    SIZE = 30GB
    ),
    (
    NAME = 'cust3', 
    FILENAME = 'I:\cust3.ndf',
    SIZE = 30GB
    ),
    (
    NAME = 'cust4', 
    FILENAME = 'J:\cust4.ndf',
    SIZE = 30GB
    ),
  FILEGROUP DS_ORDERS_FG
    (
    NAME = 'orders1', 
    FILENAME = 'G:\orders1.ndf',
    SIZE = 15GB
    ),
    (
    NAME = 'orders2', 
    FILENAME = 'H:\orders2.ndf',
    SIZE = 15GB
    ),
    (
    NAME = 'orders3', 
    FILENAME = 'I:\orders3.ndf',
    SIZE = 15GB
    ),
    (
    NAME = 'orders4', 
    FILENAME = 'J:\orders4.ndf',
    SIZE = 15GB
    ),
  FILEGROUP DS_IND_FG
    (
    NAME = 'ind1', 
    FILENAME = 'G:\ind1.ndf',
    SIZE = 8GB
    ),
    (
    NAME = 'ind2', 
    FILENAME = 'H:\ind2.ndf',
    SIZE = 8GB
    ),
    (
    NAME = 'ind3', 
    FILENAME = 'I:\ind3.ndf',
    SIZE = 8GB
    ),
    (
    NAME = 'ind4', 
    FILENAME = 'J:\ind4.ndf',
    SIZE = 8GB
    )
FILEGROUP DS_MEMBER_FG
    (
    NAME = 'member1',
    FILENAME = 'G:\member1.ndf',
    SIZE = 1GB
    ),
    (
    NAME = 'member2', 
    FILENAME = 'H:\member2.ndf',
    SIZE = 1GB
    ),
    ( 
    NAME = 'member3',
    FILENAME = 'I:\member3.ndf',
    SIZE = 1GB
    ),
    (
    NAME = 'member4', 
    FILENAME = 'J:\member4.ndf',
    SIZE = 1GB
    ),
FILEGROUP DS_REVIEW_FG
    (
    NAME = 'review1',
    FILENAME = 'G:\review1.ndf',
    SIZE = 30GB
    ),
    (
    NAME = 'review2', 
    FILENAME = 'H:\review2.ndf',
    SIZE = 30GB
    ),
    (
    NAME = 'review3',
    FILENAME = 'I:\review3.ndf',
    SIZE = 30GB
    ),
    (
    NAME = 'review4', 
    FILENAME = 'J:\review4.ndf',
    SIZE = 30GB
    )
  LOG ON
    (
    NAME = 'ds_log', 
    FILENAME = 'L:\ds_log.ldf',
    SIZE = 100GB
    )
GO

USE DS3
GO

-- Tables

CREATE TABLE CUSTOMERS
  (
  CUSTOMERID INT IDENTITY NOT NULL, 
  FIRSTNAME VARCHAR(50) NOT NULL, 
  LASTNAME VARCHAR(50) NOT NULL, 
  ADDRESS1 VARCHAR(50) NOT NULL, 
  ADDRESS2 VARCHAR(50), 
  CITY VARCHAR(50) NOT NULL, 
  STATE VARCHAR(50), 
  ZIP INT, 
  COUNTRY VARCHAR(50) NOT NULL, 
  REGION TINYINT NOT NULL,
  EMAIL VARCHAR(50),
  PHONE VARCHAR(50),
  CREDITCARDTYPE TINYINT NOT NULL,
  CREDITCARD VARCHAR(50) NOT NULL, 
  CREDITCARDEXPIRATION VARCHAR(50) NOT NULL, 
  USERNAME VARCHAR(50) NOT NULL, 
  PASSWORD VARCHAR(50) NOT NULL, 
  AGE TINYINT, 
  INCOME INT,
  GENDER VARCHAR(1)
  )
  ON DS_CUST_FG
GO  
  
CREATE TABLE CUST_HIST
  (
  CUSTOMERID INT NOT NULL, 
  ORDERID INT NOT NULL, 
  PROD_ID INT NOT NULL 
  )
  ON DS_CUST_FG
GO
  
CREATE TABLE MEMBERSHIP
  (
  CUSTOMERID INT NOT NULL, 
  MEMBERSHIPTYPE INT NOT NULL, 
  EXPIREDATE DATETIME NOT NULL 
  )
  ON DS_MEMBER_FG
GO


CREATE TABLE ORDERS
  (
  ORDERID INT IDENTITY NOT NULL, 
  ORDERDATE DATETIME NOT NULL, 
  CUSTOMERID INT NOT NULL, 
  NETAMOUNT MONEY NOT NULL, 
  TAX MONEY NOT NULL, 
  TOTALAMOUNT MONEY NOT NULL
  ) 
  ON DS_ORDERS_FG
GO

CREATE TABLE ORDERLINES
  (
  ORDERLINEID SMALLINT NOT NULL, 
  ORDERID INT NOT NULL, 
  PROD_ID INT NOT NULL, 
  QUANTITY SMALLINT NOT NULL, 
  ORDERDATE DATETIME NOT NULL
  ) 
  ON DS_ORDERS_FG
GO

CREATE TABLE PRODUCTS
  (
  PROD_ID INT IDENTITY NOT NULL, 
  CATEGORY TINYINT NOT NULL, 
  TITLE VARCHAR(50) NOT NULL, 
  ACTOR VARCHAR(50) NOT NULL, 
  PRICE MONEY NOT NULL, 
  SPECIAL TINYINT,
  COMMON_PROD_ID INT NOT NULL,
  MEMBERSHIP_ITEM INT NOT NULL
  )
  ON DS_MISC_FG
GO 

CREATE TABLE REVIEWS
  (
  REVIEW_ID INT IDENTITY NOT NULL, 
  PROD_ID INT NOT NULL,
  REVIEW_DATE DATETIME NOT NULL,
  STARS INT NOT NULL,
  CUSTOMERID INT NOT NULL, 
  REVIEW_SUMMARY VARCHAR(50) NOT NULL, 
  REVIEW_TEXT VARCHAR(1000) NOT NULL
  )
  ON DS_REVIEW_FG
GO 

CREATE TABLE REVIEWS_HELPFULNESS
  (
  REVIEW_HELPFULNESS_ID INT IDENTITY NOT NULL, 
  REVIEW_ID INT NOT NULL,
  CUSTOMERID INT NOT NULL,  
  HELPFULNESS INT NOT NULL
  )
  ON DS_REVIEW_FG
GO 

CREATE TABLE INVENTORY
  (
  PROD_ID INT NOT NULL,
  QUAN_IN_STOCK INT NOT NULL,
  SALES INT NOT NULL
  )
  ON DS_MISC_FG
GO

CREATE TABLE CATEGORIES
  (
  CATEGORY TINYINT IDENTITY NOT NULL, 
  CATEGORYNAME VARCHAR(50) NOT NULL, 
  )
  ON DS_MISC_FG
GO 

  SET IDENTITY_INSERT CATEGORIES ON 
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (1,'Action')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (2,'Animation')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (3,'Children')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (4,'Classics')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (5,'Comedy')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (6,'Documentary')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (7,'Drama')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (8,'Family')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (9,'Foreign')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (10,'Games')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (11,'Horror')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (12,'Music')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (13,'New')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (14,'Sci-Fi')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (15,'Sports')
  INSERT INTO CATEGORIES (CATEGORY, CATEGORYNAME) VALUES (16,'Travel')
  GO

CREATE TABLE REORDER
  (
  PROD_ID INT NOT NULL,
  DATE_LOW DATETIME NOT NULL,
  QUAN_LOW INT NOT NULL,
  DATE_REORDERED DATETIME,
  QUAN_REORDERED INT,
  DATE_EXPECTED DATETIME
  )
  ON DS_MISC_FG
GO

-- This keeps the number of items with low QUAN_IN_STOCK constant so that the rollback rate is constant 
CREATE TRIGGER RESTOCK ON INVENTORY AFTER UPDATE
AS
  DECLARE @changedPROD_ID INT, @oldQUAN_IN_STOCK INT, @newQUAN_IN_STOCK INT;
  IF UPDATE(QUAN_IN_STOCK)
    BEGIN
      SELECT @changedPROD_ID = i.PROD_ID, @oldQUAN_IN_STOCK = d.QUAN_IN_STOCK, @newQUAN_IN_STOCK = i.QUAN_IN_STOCK
        FROM inserted i INNER JOIN deleted d ON i.PROD_ID = d.PROD_ID
      IF @newQUAN_IN_STOCK < 3    -- assumes quantity ordered is 1, 2, or 3 - change if different
        BEGIN
          INSERT INTO REORDER
            (
            PROD_ID,
            DATE_LOW,
            QUAN_LOW
            )
          VALUES
            (
            @changedPROD_ID,
            GETDATE(),
            @newQUAN_IN_STOCK
            )
          UPDATE INVENTORY SET QUAN_IN_STOCK  = @oldQUAN_IN_STOCK WHERE PROD_ID = @changedPROD_ID
        END
    END
  RETURN
GO

DECLARE @db_id int, @tbl_id int
USE DS3
SET @db_id = DB_ID('DS3')
SET @tbl_id = OBJECT_ID('DS3..CATEGORIES')
DBCC PINTABLE (@db_id, @tbl_id)

SET @db_id = DB_ID('DS3')
SET @tbl_id = OBJECT_ID('DS3..PRODUCTS')
DBCC PINTABLE (@db_id, @tbl_id)
USE DS3
GO
