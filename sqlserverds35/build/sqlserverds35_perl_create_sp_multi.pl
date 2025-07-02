# sqlserverds3_perl_create_sp_multi.pl
# Script to create a ds3 stored procedures in sql server with a provided number of copies - supporting multiple stores
# Syntax to run - perl sqlserverds3_perl_create_sp_multi.pl <sqlserver_target> <password> <number_of_stores> 

use strict;
use warnings;

my $sqlservertarget = $ARGV [0];
my $password = $ARGV[1];
my $numberofstores = $ARGV[2];

my $sqlservertargetdir;

$sqlservertargetdir = $sqlservertarget;

# remove any backslashes from string to be used for directory name
$sqlservertargetdir =~ s/\\//;

system ("mkdir -p $sqlservertargetdir");

my $pathsep;

# This section enables support for Linux and Windows - detecting the type of OS, and then using the proper commands
if ("$^O" eq "linux")
        {
        $pathsep = "/";
        }
else
        {
        $pathsep = "\\\\";
        };

foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$sqlservertargetdir${pathsep}sqlserverds35_createsp$k.sql") || die("Can't open sqlserverds35_createsp$k.sql");
	print $OUT "-- NEW_CUSTOMER

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'NEW_CUSTOMER$k' AND type = 'P')
  DROP PROCEDURE NEW_CUSTOMER$k
GO

USE DS3
GO

CREATE PROCEDURE NEW_CUSTOMER$k
  (
  \@firstname_in             VARCHAR(50),
  \@lastname_in              VARCHAR(50),
  \@address1_in              VARCHAR(50),
  \@address2_in              VARCHAR(50),
  \@city_in                  VARCHAR(50),
  \@state_in                 VARCHAR(50),
  \@zip_in                   INT,
  \@country_in               VARCHAR(50),
  \@region_in                TINYINT,
  \@email_in                 VARCHAR(50),
  \@phone_in                 VARCHAR(50),
  \@creditcardtype_in        TINYINT,
  \@creditcard_in            VARCHAR(50),
  \@creditcardexpiration_in  VARCHAR(50),
  \@username_in              VARCHAR(50),
  \@password_in              VARCHAR(50),
  \@age_in                   TINYINT,
  \@income_in                INT,
  \@gender_in                VARCHAR(1)
  )

  AS 

  IF (SELECT COUNT(*) FROM CUSTOMERS$k WHERE USERNAME=\@username_in) = 0
  BEGIN
    INSERT INTO CUSTOMERS$k 
      (
      FIRSTNAME,
      LASTNAME,
      ADDRESS1,
      ADDRESS2,
      CITY,
      STATE,
      ZIP,
      COUNTRY,
      REGION,
      EMAIL,
      PHONE,
      CREDITCARDTYPE,
      CREDITCARD,
      CREDITCARDEXPIRATION,
      USERNAME,
      PASSWORD,
      AGE,
      INCOME,
      GENDER
      ) 
    VALUES 
      ( 
      \@firstname_in,
      \@lastname_in,
      \@address1_in,
      \@address2_in,
      \@city_in,
      \@state_in,
      \@zip_in,
      \@country_in,
      \@region_in,
      \@email_in,
      \@phone_in,
      \@creditcardtype_in,
      \@creditcard_in,
      \@creditcardexpiration_in,
      \@username_in,
      \@password_in,
      \@age_in,
      \@income_in,
      \@gender_in
      )
    SELECT \@\@IDENTITY
  END
  ELSE 
    SELECT 0
GO

-- NEW_MEMBER

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'NEW_MEMBER$k' AND type = 'P')
  DROP PROCEDURE NEW_MEMBER$k
GO

USE DS3
GO

CREATE PROCEDURE NEW_MEMBER$k
  (
  \@customerid_in            INT,
  \@membershiplevel_in       INT
  )

  AS 

  DECLARE
  \@date_in                  DATETIME

  SET DATEFORMAT ymd

  SET \@date_in = GETDATE()

  IF (SELECT COUNT(*) FROM MEMBERSHIP$k WHERE CUSTOMERID=\@customerid_in) = 0
  BEGIN
    INSERT INTO MEMBERSHIP$k
      (
      CUSTOMERID,
      MEMBERSHIPTYPE,
      EXPIREDATE
      ) 
    VALUES 
      ( 
      \@customerid_in,
      \@membershiplevel_in,
      \@date_in
      )
    SELECT \@customerid_in
  END
  ELSE 
    SELECT 0
GO

-- NEW_PROD_REVIEW

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'NEW_PROD_REVIEW$k' AND type = 'P')
  DROP PROCEDURE NEW_PROD_REVIEW$k
GO

USE DS3
GO

CREATE PROCEDURE NEW_PROD_REVIEW$k
  (
  \@prod_id_in            INT,
  \@stars_in			     INT,
  \@customerid_in		 INT,
  \@review_summary_in	 VARCHAR(50),
  \@review_text_in		 VARCHAR(1000)
  )

  AS 

  DECLARE
  \@date_in                  DATETIME

  SET DATEFORMAT ymd

  SET \@date_in = GETDATE()

  INSERT INTO REVIEWS$k
      (
      PROD_ID,
      REVIEW_DATE,
      STARS,
	  CUSTOMERID,
	  REVIEW_SUMMARY,
	  REVIEW_TEXT
      ) 
    VALUES 
      ( 
      \@prod_id_in,
      \@date_in,
      \@stars_in,
	  \@customerid_in,
	  \@review_summary_in,
	  \@review_text_in
      )
    SELECT \@\@IDENTITY
 GO


-- New review helpfulness rating

 USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'NEW_REVIEW_HELPFULNESS$k' AND type = 'P')
  DROP PROCEDURE NEW_REVIEW_HELPFULNESS$k
GO

USE DS3
GO

CREATE PROCEDURE NEW_REVIEW_HELPFULNESS$k
  (
  \@review_id_in            INT,
  \@customerid_in			     INT,
  \@review_helpfulness_in		 INT
  )

  AS 

  INSERT INTO REVIEWS_HELPFULNESS$k
      (
      REVIEW_ID,
      CUSTOMERID,
	  HELPFULNESS
	  ) 
    VALUES 
      ( 
      \@review_id_in,
   	  \@customerid_in,
	  \@review_helpfulness_in
      )
    SELECT \@\@IDENTITY
 GO


-- LOGIN

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'LOGIN$k' AND type = 'P')
  DROP PROCEDURE LOGIN$k
GO

USE DS3
GO

CREATE PROCEDURE LOGIN$k
  (
  \@username_in              VARCHAR(50),
  \@password_in              VARCHAR(50)
  )

  AS
DECLARE \@customerid_out INT
  
  SELECT \@customerid_out=CUSTOMERID FROM CUSTOMERS$k WHERE USERNAME=\@username_in AND PASSWORD=\@password_in

  IF (\@\@ROWCOUNT > 0)
    BEGIN
      SELECT \@customerid_out
      SELECT derivedtable1$k.TITLE, derivedtable1$k.ACTOR, PRODUCTS_1$k.TITLE AS RelatedPurchase
        FROM (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, PRODUCTS$k.COMMON_PROD_ID
          FROM CUST_HIST$k INNER JOIN
             PRODUCTS$k ON CUST_HIST$k.PROD_ID = PRODUCTS$k.PROD_ID
          WHERE (CUST_HIST$k.CUSTOMERID = \@customerid_out)) AS derivedtable1$k INNER JOIN
             PRODUCTS$k AS PRODUCTS_1$k ON derivedtable1$k.COMMON_PROD_ID = PRODUCTS_1$k.PROD_ID
    END
  ELSE 
    SELECT 0 
GO

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'BROWSE_BY_CATEGORY$k' AND type = 'P')
  DROP PROCEDURE BROWSE_BY_CATEGORY$k
GO

USE DS3
GO

CREATE PROCEDURE BROWSE_BY_CATEGORY$k
  (
  \@batch_size_in            INT,
  \@category_in              INT
  )

  AS 
  SET ROWCOUNT \@batch_size_in
  SELECT * FROM PRODUCTS$k WHERE CATEGORY=\@category_in and SPECIAL=1
  SET ROWCOUNT 0
GO

-- Browse by category for membertype

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'BROWSE_BY_CATEGORY_FOR_MEMBERTYPE$k' AND type = 'P')
  DROP PROCEDURE BROWSE_BY_CATEGORY_FOR_MEMBERTYPE$k
GO

USE DS3
GO

CREATE PROCEDURE BROWSE_BY_CATEGORY_FOR_MEMBERTYPE$k
  (
  \@batch_size_in            INT,
  \@category_in              INT,
  \@membershiptype_in	    INT
  )

  AS 
  SET ROWCOUNT \@batch_size_in
  SELECT * FROM PRODUCTS$k WHERE CATEGORY=\@category_in and SPECIAL=1 and MEMBERSHIP_ITEM<=\@membershiptype_in
  SET ROWCOUNT 0
GO

-- get prod reviews

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'GET_PROD_REVIEWS$k' AND type = 'P')
  DROP PROCEDURE GET_PROD_REVIEWS$k
GO

USE DS3
GO

CREATE PROCEDURE GET_PROD_REVIEWS$k
  (
  \@batch_size_in            INT,
  \@prod_in              INT
  )

  AS 
  SET ROWCOUNT \@batch_size_in

  SELECT REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, 
  REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT, SUM(REVIEWS_HELPFULNESS$k.helpfulness) as total
  FROM REVIEWS$k 
  INNER JOIN REVIEWS_HELPFULNESS$k on REVIEWS$k.REVIEW_ID=REVIEWS_HELPFULNESS$k.REVIEW_ID
  WHERE REVIEWS$k.PROD_ID = \@prod_in GROUP BY REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, 
  REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
  ORDER BY total DESC
  SET ROWCOUNT 0
GO

-- get prod reviews by stars

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'GET_PROD_REVIEWS_BY_STARS$k' AND type = 'P')
  DROP PROCEDURE GET_PROD_REVIEWS_BY_STARS$k
GO

USE DS3
GO

CREATE PROCEDURE GET_PROD_REVIEWS_BY_STARS$k
  (
  \@batch_size_in            INT,
  \@prod_in					INT,
  \@stars_in					INT
  )

  AS 
  SET ROWCOUNT \@batch_size_in

  SELECT REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, 
  REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT, SUM(REVIEWS_HELPFULNESS$k.helpfulness) as total
  FROM REVIEWS$k 
  INNER JOIN REVIEWS_HELPFULNESS$k on REVIEWS$k.REVIEW_ID=REVIEWS_HELPFULNESS$k.REVIEW_ID
  WHERE REVIEWS$k.PROD_ID = \@prod_in AND REVIEWS$k.STARS = \@stars_in GROUP BY REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, 
  REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
  ORDER BY total DESC
  SET ROWCOUNT 0
GO

-- get prod reviews by date

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'GET_PROD_REVIEWS_BY_DATE$k' AND type = 'P')
  DROP PROCEDURE GET_PROD_REVIEWS_BY_DATE$k
GO

USE DS3
GO

CREATE PROCEDURE GET_PROD_REVIEWS_BY_DATE$k
  (
  \@batch_size_in            INT,
  \@prod_in					INT
  )

  AS 
  SET ROWCOUNT \@batch_size_in

  SELECT REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, 
  REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT, SUM(REVIEWS_HELPFULNESS$k.helpfulness) as total
  FROM REVIEWS$k 
  INNER JOIN REVIEWS_HELPFULNESS$k on REVIEWS$k.REVIEW_ID=REVIEWS_HELPFULNESS$k.REVIEW_ID
  WHERE REVIEWS$k.PROD_ID = \@prod_in GROUP BY REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, 
  REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
  ORDER BY REVIEWS$k.REVIEW_DATE DESC
  SET ROWCOUNT 0
GO

-- get prod reviews by actor

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'GET_PROD_REVIEWS_BY_ACTOR$k' AND type = 'P')
  DROP PROCEDURE GET_PROD_REVIEWS_BY_ACTOR$k
GO

USE DS3
GO

CREATE PROCEDURE GET_PROD_REVIEWS_BY_ACTOR$k
  (
  \@batch_size_in            INT,
  \@actor_in					VARCHAR(50),
  \@search_depth_in					 INT = 500
  )

  AS 
  SET ROWCOUNT \@batch_size_in;

  WITH T1 (title, actor, prod_id, review_date, stars, review_id, customerid, review_summary, review_text) 
AS (SELECT TOP (\@search_depth_in) PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.REVIEW_ID,
           REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT 
    FROM PRODUCTS$k INNER JOIN REVIEWS$k on PRODUCTS$k.PROD_ID = REVIEWS$k.PROD_ID where CONTAINS (ACTOR, \@actor_in))
select T1.prod_id, T1.title, T1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, T1.review_date, T1.stars, 
                    T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS$k 
                    inner join T1 on REVIEWS_HELPFULNESS$k.REVIEW_ID = T1.review_id
					GROUP BY T1.REVIEW_ID, T1.prod_id, t1.title, t1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, t1.review_date, t1.stars, t1.customerid, t1.review_summary, t1.review_text
					ORDER BY totalhelp DESC;
  SET ROWCOUNT 0
GO

-- get prod reviews by title

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'GET_PROD_REVIEWS_BY_TITLE$k' AND type = 'P')
  DROP PROCEDURE GET_PROD_REVIEWS_BY_TITLE$k
GO

USE DS3
GO

CREATE PROCEDURE GET_PROD_REVIEWS_BY_TITLE$k
  (
  \@batch_size_in            INT,
  \@title_in					VARCHAR(50),
  \@search_depth_in					 INT = 500
  )

  AS 
  SET ROWCOUNT \@batch_size_in;

  WITH T1 (title, actor, prod_id, review_date, stars, review_id, customerid, review_summary, review_text) 
AS (SELECT TOP (\@search_depth_in) PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.REVIEW_ID,
           REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT 
    FROM PRODUCTS$k INNER JOIN REVIEWS$k on PRODUCTS$k.PROD_ID = REVIEWS$k.PROD_ID where CONTAINS (TITLE, \@title_in))
select T1.prod_id, T1.title, T1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, T1.review_date, T1.stars, 
                    T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS$k 
                    inner join T1 on REVIEWS_HELPFULNESS$k.REVIEW_ID = T1.review_id
					GROUP BY T1.REVIEW_ID, T1.prod_id, t1.title, t1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, t1.review_date, t1.stars, t1.customerid, t1.review_summary, t1.review_text
					ORDER BY totalhelp DESC;
  SET ROWCOUNT 0
GO




-- Browse by Actor

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'BROWSE_BY_ACTOR$k' AND type = 'P')
  DROP PROCEDURE BROWSE_BY_ACTOR$k
GO

USE DS3
GO

CREATE PROCEDURE BROWSE_BY_ACTOR$k
  (
  \@batch_size_in            INT,
  \@actor_in                 VARCHAR(50)
  )

  AS 

  SET ROWCOUNT \@batch_size_in
  SELECT * FROM PRODUCTS$k WITH(FORCESEEK) WHERE CONTAINS(ACTOR, \@actor_in)
  SET ROWCOUNT 0
GO

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'BROWSE_BY_TITLE$k' AND type = 'P')
  DROP PROCEDURE BROWSE_BY_TITLE$k
GO

USE DS3
GO

CREATE PROCEDURE BROWSE_BY_TITLE$k
  (
  \@batch_size_in            INT,
  \@title_in                 VARCHAR(50)
  )

  AS 

  SET ROWCOUNT \@batch_size_in
  SELECT * FROM PRODUCTS$k WITH(FORCESEEK) WHERE CONTAINS(TITLE, \@title_in)
  SET ROWCOUNT 0
GO

USE DS3
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'PURCHASE$k' AND type = 'P')
  DROP PROCEDURE PURCHASE$k
GO

USE DS3
GO

CREATE PROCEDURE PURCHASE$k
  (
  \@customerid_in            INT,
  \@number_items             INT,
  \@netamount_in             MONEY,
  \@taxamount_in             MONEY,
  \@totalamount_in           MONEY,
  \@prod_id_in0              INT = 0,     \@qty_in0     INT = 0,
  \@prod_id_in1              INT = 0,     \@qty_in1     INT = 0,
  \@prod_id_in2              INT = 0,     \@qty_in2     INT = 0,
  \@prod_id_in3              INT = 0,     \@qty_in3     INT = 0,
  \@prod_id_in4              INT = 0,     \@qty_in4     INT = 0,
  \@prod_id_in5              INT = 0,     \@qty_in5     INT = 0,
  \@prod_id_in6              INT = 0,     \@qty_in6     INT = 0,
  \@prod_id_in7              INT = 0,     \@qty_in7     INT = 0,
  \@prod_id_in8              INT = 0,     \@qty_in8     INT = 0,
  \@prod_id_in9              INT = 0,     \@qty_in9     INT = 0
  )

  AS 

  DECLARE
  \@date_in                  DATETIME,
  \@neworderid               INT,
  \@item_id                  INT,
  \@prod_id                  INT,
  \@qty                      INT,
  \@cur_quan		    INT,
  \@new_quan		    INT,
  \@cur_sales                INT,
  \@new_sales                INT
  

  SET DATEFORMAT ymd

  SET \@date_in = GETDATE()
--SET \@date_in = '2005/10/31'

  BEGIN TRANSACTION
  -- CREATE NEW ENTRY IN ORDERS TABLE
  INSERT INTO ORDERS$k
    (
    ORDERDATE,
    CUSTOMERID,
    NETAMOUNT,
    TAX,
    TOTALAMOUNT
    )
  VALUES
    (
    \@date_in,
    \@customerid_in,
    \@netamount_in,
    \@taxamount_in,
    \@totalamount_in
    )

  SET \@neworderid = \@\@IDENTITY


  -- ADD LINE ITEMS TO ORDERLINES

  SET \@item_id = 0

  WHILE (\@item_id < \@number_items)
  BEGIN
    SELECT \@prod_id = CASE \@item_id WHEN 0 THEN \@prod_id_in0
	                                WHEN 1 THEN \@prod_id_in1
	                                WHEN 2 THEN \@prod_id_in2
	                                WHEN 3 THEN \@prod_id_in3
	                                WHEN 4 THEN \@prod_id_in4
	                                WHEN 5 THEN \@prod_id_in5
	                                WHEN 6 THEN \@prod_id_in6
	                                WHEN 7 THEN \@prod_id_in7
	                                WHEN 8 THEN \@prod_id_in8
	                                WHEN 9 THEN \@prod_id_in9
    END

    SELECT \@qty = CASE \@item_id WHEN 0 THEN \@qty_in0
	                            WHEN 1 THEN \@qty_in1
	                            WHEN 2 THEN \@qty_in2
	                            WHEN 3 THEN \@qty_in3
	                            WHEN 4 THEN \@qty_in4
	                            WHEN 5 THEN \@qty_in5
	                            WHEN 6 THEN \@qty_in6
	                            WHEN 7 THEN \@qty_in7
	                            WHEN 8 THEN \@qty_in8
	                            WHEN 9 THEN \@qty_in9
    END

    SELECT \@cur_quan=QUAN_IN_STOCK, \@cur_sales=SALES FROM INVENTORY$k WHERE PROD_ID=\@prod_id

    SET \@new_quan = \@cur_quan - \@qty
    SET \@new_sales = \@cur_Sales + \@qty

    IF (\@new_quan < 0)
      BEGIN
        ROLLBACK TRANSACTION
        SELECT 0
        RETURN
      END
    ELSE
      BEGIN
        UPDATE INVENTORY$k SET QUAN_IN_STOCK=\@new_quan, SALES=\@new_sales WHERE PROD_ID=\@prod_id
        INSERT INTO ORDERLINES$k
          (
          ORDERLINEID,
          ORDERID,
          PROD_ID,
          QUANTITY,
          ORDERDATE
          )
        VALUES
          (
          \@item_id + 1,
          \@neworderid,
          \@prod_id,
          \@qty,
          \@date_in
          )
        
        INSERT INTO CUST_HIST$k
          (
          CUSTOMERID,
          ORDERID,
          PROD_ID
          )
        VALUES
          (
          \@customerid_in,
          \@neworderid,
          \@prod_id
          )
      
        SET \@item_id = \@item_id + 1
      END    
  END

  COMMIT

  SELECT \@neworderid
GO
\n";
  close $OUT;
}

sleep (1);

  
  foreach my $k (1 .. ($numberofstores-1)){
  system ("start sqlcmd -C -S $sqlservertarget -U sa -P $password -i $sqlservertargetdir${pathsep}sqlserverds35_createsp$k.sql");
  }
  system ("sqlcmd -C -S $sqlservertarget -U sa -P $password -i $sqlservertargetdir${pathsep}sqlserverds35_createsp$numberofstores.sql");


