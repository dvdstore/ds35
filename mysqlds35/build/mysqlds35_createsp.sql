Delimiter 7804
DROP PROCEDURE IF EXISTS DS3.NEW_CUSTOMER5 7804
CREATE PROCEDURE DS3.NEW_CUSTOMER5 ( IN firstname_in varchar(50), IN lastname_in varchar(50), IN address1_in varchar(50), IN address2_in varchar(50), IN city_in varchar(50), IN state_in varchar(50), IN zip_in int, IN country_in varchar(50), IN region_in int, IN email_in varchar(50), IN phone_in varchar(50), IN creditcardtype_in int, IN creditcard_in varchar(50), IN creditcardexpiration_in varchar(50), IN username_in varchar(50), IN password_in varchar(50), IN age_in int, IN income_in int, IN gender_in varchar(1), OUT customerid_out INT)
  BEGIN
  DECLARE rows_returned INT;
  SELECT COUNT(*) INTO rows_returned FROM CUSTOMERS5 WHERE USERNAME = username_in;
  IF rows_returned = 0 
  THEN
    INSERT INTO CUSTOMERS5
      (
      FIRSTNAME,
      LASTNAME,
      EMAIL,
      PHONE,
      USERNAME,
      PASSWORD,
      ADDRESS1,
      ADDRESS2,
      CITY,
      STATE,
      ZIP,
      COUNTRY,
      REGION,
      CREDITCARDTYPE,
      CREDITCARD,
      CREDITCARDEXPIRATION,
      AGE,
      INCOME,
      GENDER
      )
    VALUES
      (
      firstname_in,
      lastname_in,
      email_in,
      phone_in,
      username_in,
      password_in,
      address1_in,
      address2_in,
      city_in,
      state_in,
      zip_in,
      country_in,
      region_in,
      creditcardtype_in,
      creditcard_in,
      creditcardexpiration_in,
      age_in,
      income_in,
      gender_in
      )
      ;
    select last_insert_id() into customerid_out;
  ELSE SET customerid_out = 0;
  END IF;
  END; 7804


DROP PROCEDURE IF EXISTS DS3.NEW_MEMBER5 7804
CREATE PROCEDURE DS3.NEW_MEMBER5 ( IN customerid_in int, IN membershiplevel_in int, OUT customerid_out int)
BEGIN
  DECLARE rows_returned INT;
  SELECT COUNT(*) INTO rows_returned FROM MEMBERSHIP5 WHERE CUSTOMERID = customerid_in;
  IF rows_returned = 0
  THEN
    INSERT INTO MEMBERSHIP5
      (
      CUSTOMERID,
      MEMBERSHIPTYPE,
      EXPIREDATE
      )
      VALUES
      (
      customerid_in,
      membershiplevel_in,
      SYSDATE()
      )
      ;
    SET customerid_out = customerid_in;
  ELSE
    SET customerid_out = 0;
  END IF;
  END; 7804

DROP PROCEDURE IF EXISTS DS3.NEW_PROD_REVIEW5 7804
CREATE PROCEDURE DS3.NEW_PROD_REVIEW5
  (
  IN  prod_id_in            int,
  IN  stars_in              int,
  IN  customerid_in         int,
  IN  review_summary_in     VARCHAR(50),
  IN  review_text_in        VARCHAR(1000),
  OUT review_id_out         int
 )
BEGIN
  DECLARE rows_retunred int;
    INSERT INTO REVIEWS5
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
      prod_id_in,
      SYSDATE(),
      stars_in,
      customerid_in,
      review_summary_in,
      review_text_in
      )
      ;
    COMMIT;
    select last_insert_id() into review_id_out;
END; 7804

DROP PROCEDURE IF EXISTS DS3.NEW_REVIEW_HELPFULNESS5 7804
CREATE PROCEDURE DS3.NEW_REVIEW_HELPFULNESS5
  (
  IN  review_id_in         	int,
  IN  customerid_in         	int,
  IN  review_helpfulness_in 	int,
  OUT review_helpfulness_id_out int
 )
BEGIN
  DECLARE rows_retunred int;
    INSERT INTO REVIEWS_HELPFULNESS5
      (
      REVIEW_ID,
      CUSTOMERID,
      HELPFULNESS
      )
      VALUES
      (
      review_id_in,
      customerid_in,
      review_helpfulness_in
      )
      ;
    COMMIT;
    select last_insert_id() into review_helpfulness_id_out;
END; 7804

DROP PROCEDURE IF EXISTS DS3.LOGIN 7804
CREATE PROCEDURE DS3.LOGIN
  (
  IN username_in              VARCHAR(50),
  IN password_in              VARCHAR(50)
  )
BEGIN
  DECLARE login_customerid_out INT;

  SELECT CUSTOMERID into login_customerid_out FROM CUSTOMERS WHERE USERNAME=username_in AND PASSWORD=password_in;

  IF (FOUND_ROWS() > 0)
  THEN
      SELECT login_customerid_out;
      SELECT derivedtable1.TITLE, derivedtable1.ACTOR, PRODUCTS_1.TITLE AS RelatedPurchase
        FROM (SELECT PRODUCTS.TITLE, PRODUCTS.ACTOR, PRODUCTS.PROD_ID, PRODUCTS.COMMON_PROD_ID
          FROM DS3.CUST_HIST INNER JOIN
             PRODUCTS ON DS3.CUST_HIST.PROD_ID = PRODUCTS.PROD_ID
          WHERE (DS3.CUST_HIST.CUSTOMERID = login_customerid_out)) AS derivedtable1 INNER JOIN
             PRODUCTS AS PRODUCTS_1 ON derivedtable1.COMMON_PROD_ID = PRODUCTS_1.PROD_ID;
  ELSE
        SELECT 0;
  END IF;

END; 7804

DROP PROCEDURE IF EXISTS DS3.PURCHASE 7804
CREATE PROCEDURE DS3.PURCHASE
  (
  IN customerid_in            INT,
  IN number_items             INT,
  IN netamount_in             DECIMAL(10,2),
  IN taxamount_in             DECIMAL(10,2),
  IN totalamount_in           DECIMAL(10,2),
  IN prod_id_in0              INT,    IN qty_in0     INT,
  IN prod_id_in1              INT,    IN qty_in1     INT,
  IN prod_id_in2              INT,    IN qty_in2     INT,
  IN prod_id_in3              INT,    IN qty_in3     INT,
  IN prod_id_in4              INT,    IN qty_in4     INT,
  IN prod_id_in5              INT,    IN qty_in5     INT,
  IN prod_id_in6              INT,    IN qty_in6     INT,
  IN prod_id_in7              INT,    IN qty_in7     INT,
  IN prod_id_in8              INT,    IN qty_in8     INT,
  IN prod_id_in9              INT,    IN qty_in9     INT,
  OUT neworderid_out          INT
  )
proc_label:BEGIN

   DECLARE date_in        DATE;
   DECLARE item_id        INTEGER;
   DECLARE cur_quan       INTEGER;
   DECLARE new_quan       INTEGER;
   DECLARE cur_sales      INTEGER;
   DECLARE new_sales      INTEGER;
   DECLARE prod_id_in     INTEGER;
   DECLARE qty_in         INTEGER;

   SET date_in = NOW();

   -- CREATE NEW ENTRY IN ORDERS TABLE
    INSERT INTO DS3.ORDERS
      (
      ORDERDATE,
      CUSTOMERID,
      NETAMOUNT,
      TAX,
      TOTALAMOUNT
      )
    VALUES
      (
      date_in,
      customerid_in,
      netamount_in,
      taxamount_in,
      totalamount_in
      )
      ;

    SET neworderid_out = LAST_INSERT_ID();

    -- ADD LINE ITEMS TO ORDERLINES
    SET item_id = 0;
    WHILE item_id < number_items DO

        SET prod_id_in = CASE item_id
                WHEN 0 then prod_id_in0
                WHEN 1 then prod_id_in1
                WHEN 2 then prod_id_in2
                WHEN 3 then prod_id_in3
                WHEN 4 then prod_id_in4
                WHEN 5 then prod_id_in5
                WHEN 6 then prod_id_in6
                WHEN 7 then prod_id_in7
                WHEN 8 then prod_id_in8
                WHEN 9 then prod_id_in9
        END;

        SET qty_in = CASE item_id
                WHEN 0 then qty_in0
                WHEN 1 then qty_in1
                WHEN 2 then qty_in2
                WHEN 3 then qty_in3
                WHEN 4 then qty_in4
                WHEN 5 then qty_in5
                WHEN 6 then qty_in6
                WHEN 7 then qty_in7
                WHEN 8 then qty_in8
                WHEN 9 then qty_in9
        END;

        INSERT INTO ORDERLINES
        (
          ORDERLINEID,
          ORDERID,
          PROD_ID,
          QUANTITY,
          ORDERDATE
        )
        VALUES
        (
          item_id,
          neworderid_out,
          prod_id_in,
          qty_in,
          date_in
        )
        ;

      -- Check and update quantity in stock
      SELECT QUAN_IN_STOCK, SALES into cur_quan, cur_sales FROM DS3.INVENTORY WHERE PROD_ID=prod_id_in;

      SET new_quan = cur_quan - qty_in;
      SET new_sales = cur_sales + qty_in;

      IF new_quan < 0 THEN
        ROLLBACK;
        SET neworderid_out = 0;
        LEAVE proc_label;
      ELSE
        UPDATE DS3.INVENTORY SET QUAN_IN_STOCK = new_quan, SALES= new_sales WHERE PROD_ID=prod_id_in;

        INSERT INTO DS3.CUST_HIST
          (
          CUSTOMERID,
          ORDERID,
          PROD_ID
          )
        VALUES
          (
          customerid_in,
          neworderid_out,
          prod_id_in
          );
      END IF;

      SET item_id = item_id + 1;

    END WHILE;

    COMMIT;
END; 7804

DROP PROCEDURE IF EXISTS DS3.BROWSE_BY_TITLE 7804

CREATE PROCEDURE DS3.BROWSE_BY_TITLE
  (
  IN batch_size_in            INT,
  IN title_in                 VARCHAR(50)
  )
BEGIN
        select * from PRODUCTS where MATCH (TITLE) AGAINST (title_in) LIMIT batch_size_in;
END; 7804

DROP PROCEDURE IF EXISTS DS3.BROWSE_BY_ACTOR 7804

CREATE PROCEDURE DS3.BROWSE_BY_ACTOR
  (
  IN batch_size_in            INT,
  IN actor_in                 VARCHAR(50)
  )
BEGIN
        select * from PRODUCTS where MATCH (ACTOR) AGAINST (actor_in) LIMIT batch_size_in;
END; 7804

DROP PROCEDURE IF EXISTS DS3.BROWSE_BY_CATEGORY 7804
CREATE PROCEDURE DS3.BROWSE_BY_CATEGORY
  (
  IN batch_size_in            INT,
  IN category_in              INT,
  in special_in               INT
  )
BEGIN
        select * from PRODUCTS WHERE CATEGORY=category_in and SPECIAL=special_in limit batch_size_in;
END; 7804

DROP PROCEDURE IF EXISTS DS3.GET_PROD_REVIEWS_BY_TITLE 7804
CREATE PROCEDURE DS3.GET_PROD_REVIEWS_BY_TITLE
  (
  IN title_in                 VARCHAR(50),
  IN search_depth_in          INT
  )
BEGIN

  IF search_depth_in = '' || search_depth_in = 0
  THEN 
    SET search_depth_in = 500; 
  END IF;

select T1.prod_id, T1.title, T1.actor, REVIEWS_HELPFULNESS.REVIEW_ID, T1.review_date, T1.stars, T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS inner join (select TITLE, ACTOR, PRODUCTS.PROD_ID,REVIEWS.review_date, REVIEWS.stars, REVIEWS.review_id, REVIEWS.customerid, REVIEWS.review_summary, REVIEWS.review_text  from PRODUCTS inner join REVIEWS on PRODUCTS.prod_id = REVIEWS.prod_id where MATCH (TITLE) AGAINST ( title_in ) limit search_depth_in) as T1 on REVIEWS_HELPFULNESS.REVIEW_ID = T1.review_id GROUP BY REVIEW_ID ORDER BY totalhelp DESC limit 10;

END; 7804

DROP PROCEDURE IF EXISTS DS3.GET_PROD_REVIEWS_BY_ACTOR 7804
CREATE PROCEDURE DS3.GET_PROD_REVIEWS_BY_ACTOR
  (
  IN actor_in                 VARCHAR(50),
  IN search_depth_in          INT
  )
BEGIN

  IF search_depth_in = '' || search_depth_in = 0
  THEN
    SET search_depth_in = 500;
  END IF;

select T1.prod_id, T1.title, T1.actor, REVIEWS_HELPFULNESS.REVIEW_ID, T1.review_date, T1.stars, T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS inner join (select TITLE, ACTOR, PRODUCTS.PROD_ID,REVIEWS.review_date, REVIEWS.stars, REVIEWS.review_id, REVIEWS.customerid, REVIEWS.review_summary, REVIEWS.review_text  from PRODUCTS inner join REVIEWS on PRODUCTS.prod_id = REVIEWS.prod_id where MATCH (ACTOR) AGAINST ( actor_in ) limit search_depth_in) as T1 on REVIEWS_HELPFULNESS.REVIEW_ID = T1.review_id GROUP BY REVIEW_ID ORDER BY totalhelp DESC limit 10;

END; 7804

DROP PROCEDURE IF EXISTS DS3.GET_PROD_REVIEWS 7804
CREATE PROCEDURE DS3.GET_PROD_REVIEWS
  (
  IN batch_size_in        INT,
  IN prod_in              INT
  )
BEGIN

SELECT REVIEWS.review_id, REVIEWS.prod_id, REVIEWS.review_date, REVIEWS.stars, REVIEWS.customerid,REVIEWS.review_summary, REVIEWS.review_text, SUM(REVIEWS_HELPFULNESS1.helpfulness) as total FROM REVIEWS INNER JOIN REVIEWS_HELPFULNESS1 on REVIEWS.review_id=REVIEWS_HELPFULNESS1.review_id WHERE PROD_ID = prod_in GROUP BY REVIEWS.review_id ORDER BY total DESC limit batch_size_in;

END; 7804

DROP PROCEDURE IF EXISTS DS3.GET_PROD_REVIEWS_BY_STARS 7804
CREATE PROCEDURE DS3.GET_PROD_REVIEWS_BY_STARS
  (
  IN batch_size_in        INT,
  IN stars_in             INT,
  IN prod_in              INT
  )
BEGIN

SELECT REVIEWS.review_id, REVIEWS.prod_id, REVIEWS.review_date, REVIEWS.stars, REVIEWS.customerid,REVIEWS.review_summary, REVIEWS.review_text, SUM(REVIEWS_HELPFULNESS1.helpfulness) as total FROM REVIEWS INNER JOIN REVIEWS_HELPFULNESS1 on REVIEWS.review_id=REVIEWS_HELPFULNESS1.review_id WHERE PROD_ID = prod_in AND STARS = stars_in GROUP BY REVIEWS.review_id ORDER BY total DESC limit batch_size_in;

END; 7804

DROP PROCEDURE IF EXISTS DS3.GET_PROD_REVIEWS_BY_DATE 7804
CREATE PROCEDURE DS3.GET_PROD_REVIEWS_BY_DATE
  (
  IN batch_size_in        INT,
  IN prod_in              INT
  )
BEGIN

SELECT REVIEWS.review_id, REVIEWS.prod_id, REVIEWS.review_date, REVIEWS.stars, REVIEWS.customerid,REVIEWS.review_summary, REVIEWS.review_text, SUM(REVIEWS_HELPFULNESS1.helpfulness) as total FROM REVIEWS INNER JOIN REVIEWS_HELPFULNESS1 on REVIEWS.review_id=REVIEWS_HELPFULNESS1.review_id WHERE PROD_ID = prod_in GROUP BY REVIEWS.review_id ORDER BY REVIEW_DATE DESC limit batch_size_in;

END; 7804
