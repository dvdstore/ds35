# oracleds3_perl_create_sp_multi.pl
# Script to create a ds3 stored procedures in oracle with a provided number of copies - supporting multiple stores
# Syntax to run - perl oracleds3_perl_create_sp_multi.pl <oracle_target> <number_of_stores> 

use strict;
use warnings;

my $oracletarget = $ARGV [0];
my $numberofstores = $ARGV[1];

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $oracletargetdir;  

$oracletargetdir = $oracletarget;

# remove any backslashes from string to be used for directory name
$oracletargetdir =~ s/\\//;

system ("mkdir $oracletargetdir");


foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$oracletargetdir\\oracleds35_createsp$k.sql") || die("Can't open oracleds35_createsp$k.sql");
	print $OUT "CREATE GLOBAL TEMPORARY TABLE derivedtable1$k 
  ON COMMIT PRESERVE ROWS
  AS SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, PRODUCTS$k.COMMON_PROD_ID
  FROM DS3.CUST_HIST$k INNER JOIN
    DS3.PRODUCTS$k ON CUST_HIST$k.PROD_ID = PRODUCTS$k.PROD_ID;

  
CREATE OR REPLACE  PROCEDURE \"DS3\".\"NEW_CUSTOMER$k\" 
  (
  firstname_in DS3.CUSTOMERS$k.FIRSTNAME%TYPE,
  lastname_in DS3.CUSTOMERS$k.LASTNAME%TYPE,
  address1_in DS3.CUSTOMERS$k.ADDRESS1%TYPE,
  address2_in DS3.CUSTOMERS$k.ADDRESS2%TYPE,
  city_in DS3.CUSTOMERS$k.CITY%TYPE,
  state_in DS3.CUSTOMERS$k.STATE%TYPE,
  zip_in DS3.CUSTOMERS$k.ZIP%TYPE,
  country_in DS3.CUSTOMERS$k.COUNTRY%TYPE,
  region_in DS3.CUSTOMERS$k.REGION%TYPE,
  email_in DS3.CUSTOMERS$k.EMAIL%TYPE,
  phone_in DS3.CUSTOMERS$k.PHONE%TYPE,
  creditcardtype_in DS3.CUSTOMERS$k.CREDITCARDTYPE%TYPE,
  creditcard_in DS3.CUSTOMERS$k.CREDITCARD%TYPE,
  creditcardexpiration_in DS3.CUSTOMERS$k.CREDITCARDEXPIRATION%TYPE,
  username_in DS3.CUSTOMERS$k.USERNAME%TYPE,
  password_in DS3.CUSTOMERS$k.PASSWORD%TYPE,
  age_in DS3.CUSTOMERS$k.AGE%TYPE,
  income_in DS3.CUSTOMERS$k.INCOME%TYPE,
  gender_in DS3.CUSTOMERS$k.GENDER%TYPE,
  customerid_out OUT INTEGER
  )
  IS
  rows_returned INTEGER;
  BEGIN

    SELECT COUNT(*) INTO rows_returned FROM CUSTOMERS$k WHERE USERNAME = username_in;

    IF rows_returned = 0
    THEN
      SELECT CUSTOMERID_SEQ$k.NEXTVAL INTO customerid_out FROM DUAL;
      INSERT INTO CUSTOMERS$k
        (
        CUSTOMERID,
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
        customerid_out,
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
      COMMIT;

    ELSE customerid_out := 0;

    END IF;

    END NEW_CUSTOMER$k;
/

CREATE OR REPLACE  PROCEDURE \"DS3\".\"NEW_MEMBER$k\"
  (
  customerid_in INTEGER,
  membershiplevel_in INTEGER,
  customerid_out OUT INTEGER
  )
  IS
  rows_returned INTEGER;
  BEGIN

    SELECT COUNT(*) INTO rows_returned FROM MEMBERSHIP$k WHERE CUSTOMERID = customerid_in;

    IF rows_returned = 0
    THEN
      INSERT INTO MEMBERSHIP$k
        (CUSTOMERID,
         MEMBERSHIPTYPE,
         EXPIREDATE
         )
      VALUES
        (
        customerid_in,
        membershiplevel_in,
        SYSDATE
        );
      customerid_out := customerid_in;
    ELSE
      customerid_out := 0;
    END IF;
    END NEW_MEMBER$k;
/




CREATE OR REPLACE PROCEDURE \"DS3\".\"NEW_PROD_REVIEW$k\"
  (
  prod_id_in 		IN DS3.REVIEWS$k.PROD_ID%TYPE,
  stars_in 		IN DS3.REVIEWS$k.STARS%TYPE,
  customerid_in 	IN DS3.REVIEWS$k.CUSTOMERID%TYPE,
  review_summary_in 	IN DS3.REVIEWS$k.REVIEW_SUMMARY%TYPE,
  review_text_in 	IN DS3.REVIEWS$k.REVIEW_TEXT%TYPE,
  review_id_out 	OUT INTEGER
 )
  IS
  rows_returned INTEGER;
  BEGIN

      SELECT REVIEWID_SEQ$k.NEXTVAL INTO review_id_out FROM DUAL;
      INSERT INTO REVIEWS$k
        (
        REVIEW_ID,
        PROD_ID,
        REVIEW_DATE,
        STARS,
        CUSTOMERID,
        REVIEW_SUMMARY,
        REVIEW_TEXT
        )
        VALUES
        (
        review_id_out,
        prod_id_in,
	SYSDATE,
        stars_in,
        customerid_in,
        review_summary_in,
        review_text_in
        )
        ;
      COMMIT;
END NEW_PROD_REVIEW$k; 
/

CREATE OR REPLACE PROCEDURE \"DS3\".\"NEW_REVIEW_HELPFULNESS$k\"
  (
  review_id_in          	IN DS3.REVIEWS_HELPFULNESS$k.REVIEW_ID%TYPE,
  customerid_in         	IN DS3.REVIEWS_HELPFULNESS$k.CUSTOMERID%TYPE,
  review_helpfulness_in 	IN DS3.REVIEWS_HELPFULNESS$k.HELPFULNESS%TYPE,
  review_helpfulness_id_out     OUT INTEGER
 )
  IS
  rows_returned INTEGER;
  BEGIN

      SELECT REVIEWHELPFULNESSID_SEQ$k.NEXTVAL INTO review_helpfulness_id_out FROM DUAL;
      INSERT INTO REVIEWS_HELPFULNESS$k
        (
        REVIEW_HELPFULNESS_ID,
        REVIEW_ID,
        CUSTOMERID,
        HELPFULNESS
        )
        VALUES
        (
        review_helpfulness_id_out,
        review_id_in,
        customerid_in,
        review_helpfulness_in
        )
        ;
      COMMIT;
END NEW_REVIEW_HELPFULNESS$k;
/


CREATE OR REPLACE  PROCEDURE \"DS3\".\"LOGIN$k\" 
  (
  username_in        IN  DS3.CUSTOMERS$k.USERNAME%TYPE,
  password_in        IN  DS3.CUSTOMERS$k.PASSWORD%TYPE,
  batch_size         IN  INTEGER,
  found              OUT INTEGER,
  customerid_out     OUT INTEGER,
  title_out          OUT DS3_TYPES.ARRAY_TYPE,
  actor_out          OUT DS3_TYPES.ARRAY_TYPE,
  related_title_out  OUT DS3_TYPES.ARRAY_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN
    
    SELECT CUSTOMERID INTO customerid_out FROM CUSTOMERS$k WHERE USERNAME = username_in AND PASSWORD = password_in;
    
    delete from derivedtable1$k;

    insert into derivedtable1$k select products$k.title, products$k.actor, products$k.prod_id, products$k.common_prod_id
        from cust_hist$k inner join products$k on cust_hist$k.prod_id = products$k.prod_id
       where (cust_hist$k.customerid = customerid_out);
    OPEN result_cv FOR
      SELECT derivedtable1$k.TITLE, derivedtable1$k.ACTOR, PRODUCTS$k.TITLE AS RelatedTitle
        FROM
          derivedtable1$k INNER JOIN
            PRODUCTS$k ON derivedtable1$k.COMMON_PROD_ID = PRODUCTS$k.PROD_ID;
    
    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO title_out(i), actor_out(i), related_title_out(i);
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    customerid_out := 0;
  
  END LOGIN$k;
/


CREATE OR REPLACE PROCEDURE \"DS3\".\"BROWSE_BY_CATEGORY$k\" 
  (
  batch_size   IN INTEGER,
  found        OUT INTEGER,
  category_in  IN INTEGER,
  prod_id_out  OUT DS3_TYPES.N_TYPE,
  category_out OUT DS3_TYPES.N_TYPE,
  title_out    OUT DS3_TYPES.ARRAY_TYPE,
  actor_out    OUT DS3_TYPES.ARRAY_TYPE,
  price_out    OUT DS3_TYPES.N_TYPE,
  special_out  OUT DS3_TYPES.N_TYPE,
  common_prod_id_out  OUT DS3_TYPES.N_TYPE,
  membership_item_out OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;
  
  BEGIN
  
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM PRODUCTS$k WHERE CATEGORY = category_in AND SPECIAL = 1;
    END IF;
  
    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO prod_id_out(i), category_out(i), title_out(i), actor_out(i), price_out(i), special_out(i), common_prod_id_out(i), membership_item_out(i);
      IF result_cv%NOTFOUND THEN 
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;
  END BROWSE_BY_CATEGORY$k;
/  


CREATE OR REPLACE PROCEDURE \"DS3\".\"BROWSE_BY_CAT_FOR_MEMBERTY$k\"
  (
  batch_size   		IN INTEGER,
  found       		OUT INTEGER,
  category_in  		IN INTEGER,
  membershiptype_in 	IN INTEGER,
  prod_id_out  		OUT DS3_TYPES.N_TYPE,
  category_out 		OUT DS3_TYPES.N_TYPE,
  title_out    		OUT DS3_TYPES.ARRAY_TYPE,
  actor_out    		OUT DS3_TYPES.ARRAY_TYPE,
  price_out    		OUT DS3_TYPES.N_TYPE,
  special_out  		OUT DS3_TYPES.N_TYPE,
  common_prod_id_out  	OUT DS3_TYPES.N_TYPE,
  membership_item_out   OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN

    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM PRODUCTS$k WHERE CATEGORY = category_in AND SPECIAL = 1 AND MEMBERSHIP_ITEM <= membershiptype_in;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO prod_id_out(i), category_out(i), title_out(i), actor_out(i), price_out(i), special_out(i), common_prod_id_out(i), membership_item_out(i);
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;
  END BROWSE_BY_CAT_FOR_MEMBERTY$k;
/



CREATE OR REPLACE PROCEDURE GET_PROD_REVIEWS$k
(
   batch_size                  IN INTEGER,
   found                       OUT INTEGER,
   prod_in                     IN  INTEGER,
   review_id_out               OUT DS3_TYPES.N_TYPE,
   prod_id_out                 OUT DS3_TYPES.N_TYPE,
   review_date_out             OUT DS3_TYPES.ARRAY_TYPE,
   review_stars_out            OUT DS3_TYPES.N_TYPE,
   review_customerid_out       OUT DS3_TYPES.N_TYPE,
   review_summary_out          OUT DS3_TYPES.ARRAY_TYPE,
   review_text_out             OUT DS3_TYPES.LONG_ARRAY_TYPE,
   review_helpfulness_sum_out  OUT DS3_TYPES.N_TYPE
  )
AS 
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;
BEGIN
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      WITH s1 AS (SELECT review_id, SUM(helpfulness) AS total FROM 
        (SELECT prod_id, review_id, stars, helpfulness  FROM 
        (SELECT reviews$k.prod_id, reviews$k.review_id, reviews_helpfulness$k.helpfulness, reviews$k.stars FROM
        reviews$k INNER JOIN reviews_helpfulness$k ON reviews$k.review_id=reviews_helpfulness$k.review_id WHERE 
        reviews$k.prod_id = prod_in))
        GROUP BY review_id ORDER BY sum(helpfulness) DESC)
      SELECT s1.review_id, reviews$k.prod_id, reviews$k.review_date, reviews$k.stars, reviews$k.customerid, reviews$k.review_summary, reviews$k.review_text, s1.total FROM
      s1 INNER JOIN reviews$k on reviews$k.review_id=s1.review_id;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO review_id_out(i), prod_id_out(i), review_date_out(i), review_stars_out(i), review_customerid_out(i), review_summary_out(i), review_text_out(i), review_helpfulness_sum_out(i);
      IF review_helpfulness_sum_out(i) IS NULL THEN
        review_helpfulness_sum_out(i) := 0;
      END IF;
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        found := 0;

  END GET_PROD_REVIEWS$k;
/

  
CREATE OR REPLACE  PROCEDURE \"DS3\".\"GET_PROD_REVIEWS_BY_STARS$k\"
  (
   batch_size                  IN INTEGER,
   found                       OUT INTEGER,
   prod_in                     IN  INTEGER,
   stars_in                    IN  INTEGER,
   review_id_out               OUT DS3_TYPES.N_TYPE,
   prod_id_out                 OUT DS3_TYPES.N_TYPE,
   review_date_out             OUT DS3_TYPES.ARRAY_TYPE,
   review_stars_out            OUT DS3_TYPES.N_TYPE,
   review_customerid_out       OUT DS3_TYPES.N_TYPE,
   review_summary_out          OUT DS3_TYPES.ARRAY_TYPE,
   review_text_out             OUT DS3_TYPES.LONG_ARRAY_TYPE,
   review_helpfulness_sum_out  OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      WITH s1 AS (SELECT review_id, SUM(helpfulness) AS total FROM 
        (SELECT prod_id, review_id, stars, helpfulness  FROM 
        (SELECT reviews$k.prod_id, reviews$k.review_id, reviews_helpfulness$k.helpfulness, reviews$k.stars FROM
        reviews$k INNER JOIN reviews_helpfulness$k ON reviews$k.review_id=reviews_helpfulness$k.review_id WHERE 
        reviews$k.prod_id = prod_in)WHERE stars = stars_in)
        GROUP BY review_id ORDER BY sum(helpfulness) DESC)
      SELECT s1.review_id, reviews$k.prod_id, reviews$k.review_date, reviews$k.stars, reviews$k.customerid, reviews$k.review_summary, reviews$k.review_text, s1.total FROM
      s1 INNER JOIN reviews$k on reviews$k.review_id=s1.review_id;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO review_id_out(i), prod_id_out(i), review_date_out(i), review_stars_out(i), review_customerid_out(i), review_summary_out(i), review_text_out(i), review_helpfulness_sum_out(i);
       IF review_helpfulness_sum_out(i) IS NULL THEN
        review_helpfulness_sum_out(i) := 0;
      END IF;
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        found := 0;

  END GET_PROD_REVIEWS_BY_STARS$k;
/


CREATE OR REPLACE  PROCEDURE \"DS3\".\"GET_PROD_REVIEWS_BY_DATE$k\"
  (
   batch_size                  IN INTEGER,
   found                       OUT INTEGER,
   prod_in                     IN  INTEGER,
   review_id_out               OUT DS3_TYPES.N_TYPE,
   prod_id_out                 OUT DS3_TYPES.N_TYPE,
   review_date_out             OUT DS3_TYPES.ARRAY_TYPE,
   review_stars_out            OUT DS3_TYPES.N_TYPE,
   review_customerid_out       OUT DS3_TYPES.N_TYPE,
   review_summary_out          OUT DS3_TYPES.ARRAY_TYPE,
   review_text_out             OUT DS3_TYPES.LONG_ARRAY_TYPE,
   review_helpfulness_sum_out  OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM REVIEWS$k WHERE PROD_ID = prod_in ORDER BY REVIEW_DATE DESC;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO review_id_out(i), prod_id_out(i), review_date_out(i), review_stars_out(i), review_customerid_out(i), review_summary_out(i), review_text_out(i);
      SELECT SUM(helpfulness) INTO review_helpfulness_sum_out(i) from reviews_helpfulness$k where REVIEW_ID = review_id_out(i);
      IF review_helpfulness_sum_out(i) IS NULL THEN
        review_helpfulness_sum_out(i) := 0;
      END IF;
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        found := 0;

  END GET_PROD_REVIEWS_BY_DATE$k;
/


CREATE OR REPLACE  PROCEDURE \"DS3\".\"GET_PROD_REVIEWS_BY_ACTOR$k\"
  (
   batch_size                  IN INTEGER,
   search_depth				   IN INTEGER DEFAULT 10,
   found                       OUT INTEGER,
   actor_in                    IN  VARCHAR2,
   title_out		       OUT DS3_TYPES.ARRAY_TYPE,
   actor_out		       OUT DS3_TYPES.ARRAY_TYPE,
   review_id_out               OUT DS3_TYPES.N_TYPE,
   prod_id_out                 OUT DS3_TYPES.N_TYPE,
   review_date_out             OUT DS3_TYPES.ARRAY_TYPE,
   review_stars_out            OUT DS3_TYPES.N_TYPE,
   review_customerid_out       OUT DS3_TYPES.N_TYPE,
   review_summary_out          OUT DS3_TYPES.ARRAY_TYPE,
   review_text_out             OUT DS3_TYPES.LONG_ARRAY_TYPE,
   review_helpfulness_sum_out  OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN

    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
	WITH T1 AS 
          (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.REVIEW_ID,
           REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT 
           FROM PRODUCTS$k INNER JOIN REVIEWS$k on PRODUCTS$k.PROD_ID = REVIEWS$k.PROD_ID where CONTAINS (ACTOR, actor_in) > 0 AND ROWNUM<= search_depth )
         select T1.title, T1.actor, T1.REVIEW_ID, T1.prod_id, T1.review_date, T1.stars, 
                T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS$k 
         inner join T1 on REVIEWS_HELPFULNESS$k.REVIEW_ID = T1.review_id
	 GROUP BY T1.REVIEW_ID, T1.prod_id, t1.title, t1.actor, t1.review_date, t1.stars, t1.customerid, t1.review_summary, t1.review_text
	 ORDER BY totalhelp DESC;       
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO title_out(i), actor_out(i),review_id_out(i), prod_id_out(i), review_date_out(i), review_stars_out(i), review_customerid_out(i), review_summary_out(i), review_text_out(i), review_helpfulness_sum_out(i);
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
	    IF review_helpfulness_sum_out(i) IS NULL THEN
          review_helpfulness_sum_out(i) := 0;
        END IF;
        found := found + 1;
      END IF;
    END LOOP;
  END GET_PROD_REVIEWS_BY_ACTOR$k;
/


CREATE OR REPLACE  PROCEDURE \"DS3\".\"GET_PROD_REVIEWS_BY_TITLE$k\"
  (
   batch_size                  IN INTEGER,
   search_depth				   IN INTEGER DEFAULT 10,
   found                       OUT INTEGER,
   title_in                    IN  VARCHAR2,
   title_out                   OUT DS3_TYPES.ARRAY_TYPE,
   actor_out                   OUT DS3_TYPES.ARRAY_TYPE,
   review_id_out               OUT DS3_TYPES.N_TYPE,
   prod_id_out                 OUT DS3_TYPES.N_TYPE,
   review_date_out             OUT DS3_TYPES.ARRAY_TYPE,
   review_stars_out            OUT DS3_TYPES.N_TYPE,
   review_customerid_out       OUT DS3_TYPES.N_TYPE,
   review_summary_out          OUT DS3_TYPES.ARRAY_TYPE,
   review_text_out             OUT DS3_TYPES.LONG_ARRAY_TYPE,
   review_helpfulness_sum_out  OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN

    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
	WITH T1 AS
          (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.REVIEW_ID,
           REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
           FROM PRODUCTS$k INNER JOIN REVIEWS$k on PRODUCTS$k.PROD_ID = REVIEWS$k.PROD_ID where CONTAINS (TITLE, title_in) > 0 AND ROWNUM<= search_depth )
         select T1.title, T1.actor, T1.REVIEW_ID, T1.prod_id, T1.review_date, T1.stars,
                T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS$k
         inner join T1 on REVIEWS_HELPFULNESS$k.REVIEW_ID = T1.review_id
         GROUP BY T1.REVIEW_ID, T1.prod_id, t1.title, t1.actor, t1.review_date, t1.stars, t1.customerid, t1.review_summary, t1.review_text
         ORDER BY totalhelp DESC;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO title_out(i), actor_out(i),review_id_out(i), prod_id_out(i), review_date_out(i), review_stars_out(i), review_customerid_out(i), review_summary_out(i), review_text_out(i), review_helpfulness_sum_out(i);
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
	    IF review_helpfulness_sum_out(i) IS NULL THEN
          review_helpfulness_sum_out(i) := 0;
        END IF;
        found := found + 1;
      END IF;
    END LOOP;
  END GET_PROD_REVIEWS_BY_TITLE$k;
/




CREATE OR REPLACE  PROCEDURE \"DS3\".\"BROWSE_BY_ACTOR$k\"
  (
  batch_size   IN INTEGER,
  found        OUT INTEGER,
  actor_in     IN  VARCHAR2,
  prod_id_out  OUT DS3_TYPES.N_TYPE,
  category_out OUT DS3_TYPES.N_TYPE,
  title_out    OUT DS3_TYPES.ARRAY_TYPE,
  actor_out    OUT DS3_TYPES.ARRAY_TYPE,
  price_out    OUT DS3_TYPES.N_TYPE,
  special_out  OUT DS3_TYPES.N_TYPE,
  common_prod_id_out  OUT DS3_TYPES.N_TYPE,
  membership_item_out OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;
  
  BEGIN
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM PRODUCTS$k WHERE CONTAINS(ACTOR, actor_in) > 0;
    END IF;
  
    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO prod_id_out(i), category_out(i), title_out(i), actor_out(i), price_out(i), special_out(i), common_prod_id_out(i), membership_item_out(i);
      IF result_cv%NOTFOUND THEN 
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;
  END BROWSE_BY_ACTOR$k;
/


CREATE OR REPLACE  PROCEDURE \"DS3\".\"BROWSE_BY_ACTOR_FOR_MEMBERTY$k\"
  (
  batch_size   		IN INTEGER,
  found        		OUT INTEGER,
  actor_in     		IN  VARCHAR2,
  membershiptype_in  	IN INTEGER,
  prod_id_out  		OUT DS3_TYPES.N_TYPE,
  category_out 		OUT DS3_TYPES.N_TYPE,
  title_out    		OUT DS3_TYPES.ARRAY_TYPE,
  actor_out    		OUT DS3_TYPES.ARRAY_TYPE,
  price_out    		OUT DS3_TYPES.N_TYPE,
  special_out  		OUT DS3_TYPES.N_TYPE,
  common_prod_id_out  	OUT DS3_TYPES.N_TYPE,
  membership_item_out   OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM PRODUCTS$k WHERE CONTAINS(ACTOR, actor_in) > 0 AND MEMBERSHIP_ITEM <= membershiptype_in;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO prod_id_out(i), category_out(i), title_out(i), actor_out(i), price_out(i), special_out(i), common_prod_id_out(i), membership_item_out(i);
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;
  END BROWSE_BY_ACTOR_FOR_MEMBERTY$k;
/

  
  
CREATE OR REPLACE  PROCEDURE \"DS3\".\"BROWSE_BY_TITLE$k\"
  (
  batch_size   IN  INTEGER,
  found        OUT INTEGER,
  title_in     IN  VARCHAR2,
  prod_id_out  OUT DS3_TYPES.N_TYPE,
  category_out OUT DS3_TYPES.N_TYPE,
  title_out    OUT DS3_TYPES.ARRAY_TYPE,
  actor_out    OUT DS3_TYPES.ARRAY_TYPE,
  price_out    OUT DS3_TYPES.N_TYPE,
  special_out  OUT DS3_TYPES.N_TYPE,
  common_prod_id_out  OUT DS3_TYPES.N_TYPE,
  membership_item_out OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;
  
  BEGIN
  
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM PRODUCTS$k WHERE CONTAINS(TITLE, title_in) > 0;
    END IF;
  
    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO prod_id_out(i), category_out(i), title_out(i), actor_out(i), price_out(i), special_out(i), common_prod_id_out(i), membership_item_out(i);
      IF result_cv%NOTFOUND THEN 
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;
  END BROWSE_BY_TITLE$k;
/
 

CREATE OR REPLACE  PROCEDURE \"DS3\".\"BROWSE_BY_TITLE_FOR_MEMBERTY$k\"
  (
  batch_size            IN INTEGER,
  found                 OUT INTEGER,
  title_in              IN VARCHAR2,
  membershiptype_in     IN INTEGER,
  prod_id_out           OUT DS3_TYPES.N_TYPE,
  category_out          OUT DS3_TYPES.N_TYPE,
  title_out             OUT DS3_TYPES.ARRAY_TYPE,
  actor_out             OUT DS3_TYPES.ARRAY_TYPE,
  price_out             OUT DS3_TYPES.N_TYPE,
  special_out           OUT DS3_TYPES.N_TYPE,
  common_prod_id_out    OUT DS3_TYPES.N_TYPE,
  membership_item_out   OUT DS3_TYPES.N_TYPE
  )
  AS
  result_cv DS3_TYPES.DS3_CURSOR;
  i INTEGER;

  BEGIN
    IF NOT result_cv%ISOPEN THEN
      OPEN result_cv FOR
      SELECT * FROM PRODUCTS$k WHERE CONTAINS(TITLE, title_in) > 0 AND MEMBERSHIP_ITEM <= membershiptype_in;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO prod_id_out(i), category_out(i), title_out(i), actor_out(i), price_out(i), special_out(i), common_prod_id_out(i), membership_item_out(i);
      IF result_cv%NOTFOUND THEN
        CLOSE result_cv;
        EXIT;
      ELSE
        found := found + 1;
      END IF;
    END LOOP;
  END BROWSE_BY_TITLE_FOR_MEMBERTY$k;
/


 
  
CREATE OR REPLACE  PROCEDURE \"DS3\".\"PURCHASE$k\"
  (
  customerid_in   IN INTEGER,
  number_items    IN INTEGER,
  netamount_in    IN NUMBER,
  taxamount_in    IN NUMBER,
  totalamount_in  IN NUMBER,
  neworderid_out  OUT INTEGER,
  prod_id_in      IN DS3_TYPES.N_TYPE,
  qty_in          IN DS3_TYPES.N_TYPE
  )
  AS
  date_in        DATE;
  item_id        INTEGER;
  price          NUMBER;
  cur_quan       NUMBER;
  new_quan       NUMBER;
  cur_sales      NUMBER;
  new_sales      NUMBER;
  prod_id_temp   DS3_TYPES.N_TYPE;

  BEGIN

    SELECT ORDERID_SEQ$k.NEXTVAL INTO neworderid_out FROM DUAL;

    date_in := SYSDATE;
--  date_in := TO_DATE('2005/1/1', 'YYYY/MM/DD');

    COMMIT;

  -- Start Transaction
    SET TRANSACTION NAME 'FillOrder';

  

  -- CREATE NEW ENTRY IN ORDERS TABLE
    INSERT INTO ORDERS$k
      (
      ORDERID,
      ORDERDATE,
      CUSTOMERID,
      NETAMOUNT,
      TAX,
      TOTALAMOUNT
      )
    VALUES
      (
      neworderid_out,
      date_in,
      customerid_in,
      netamount_in,
      taxamount_in,
      totalamount_in
      )
      ;

    -- ADD LINE ITEMS TO ORDERLINES

    FOR item_id IN 1..number_items LOOP
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
        item_id,
        neworderid_out,
        prod_id_in(item_id),
        qty_in(item_id),
        date_in
        )
        ;
   -- Check and update quantity in stock
      SELECT QUAN_IN_STOCK, SALES into cur_quan, cur_sales FROM INVENTORY$k WHERE PROD_ID=prod_id_in(item_id);
      new_quan := cur_quan - qty_in(item_id);
      new_sales := cur_sales + qty_in(item_id);
      IF new_quan < 0 THEN
        ROLLBACK;
        neworderid_out := 0;
        RETURN;
      ELSE
        IF new_quan < 3 THEN  -- this is kluge to keep rollback rate constant - assumes 1, 2 or 3 quan ordered
          UPDATE INVENTORY$k SET SALES= new_sales WHERE PROD_ID=prod_id_in(item_id);
        ELSE
          UPDATE INVENTORY$k SET QUAN_IN_STOCK = new_quan, SALES= new_sales WHERE PROD_ID=prod_id_in(item_id);
        END IF;
        INSERT INTO CUST_HIST$k
          (
          CUSTOMERID,
          ORDERID,
          PROD_ID
          )
        VALUES
          (
          customerid_in,
          neworderid_out,
          prod_id_in(item_id)
          );
      END IF;
    END LOOP;

    COMMIT;

  END PURCHASE$k;
/

CREATE OR REPLACE TRIGGER \"DS3\".\"RESTOCK$k\" 
AFTER UPDATE OF \"QUAN_IN_STOCK\" ON \"DS3\".\"INVENTORY$k\" 
FOR EACH ROW WHEN (NEW.QUAN_IN_STOCK < 10) 

DECLARE
  X NUMBER;
BEGIN 
  SELECT COUNT(*) INTO X FROM DS3.REORDER$k WHERE PROD_ID = :NEW.PROD_ID;
  IF x = 0 THEN
    INSERT INTO DS3.REORDER$k(PROD_ID, DATE_LOW, QUAN_LOW) VALUES(:NEW.PROD_ID, SYSDATE, :NEW.QUAN_IN_STOCK);
  END IF;
END RESTOCK$k;
/


exit;\n";
  close $OUT;
}

sleep (1);

foreach my $k (1 .. ($numberofstores-1)){
  system ("start sqlplus \"ds3/ds3\@$oracletarget\" \@$oracletargetdir\\oracleds35_createsp$k.sql");
  }
  system ("sqlplus \"ds3/ds3\@$oracletarget\" \@$oracletargetdir\\oracleds35_createsp$numberofstores.sql");

