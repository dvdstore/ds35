CREATE GLOBAL TEMPORARY TABLE derivedtable13 
  ON COMMIT PRESERVE ROWS
  AS SELECT PRODUCTS3.TITLE, PRODUCTS3.ACTOR, PRODUCTS3.PROD_ID, PRODUCTS3.COMMON_PROD_ID
  FROM DS3.CUST_HIST3 INNER JOIN
    DS3.PRODUCTS3 ON CUST_HIST3.PROD_ID = PRODUCTS3.PROD_ID;

  
CREATE OR REPLACE  PROCEDURE "DS3"."NEW_CUSTOMER3" 
  (
  firstname_in DS3.CUSTOMERS3.FIRSTNAME%TYPE,
  lastname_in DS3.CUSTOMERS3.LASTNAME%TYPE,
  address1_in DS3.CUSTOMERS3.ADDRESS1%TYPE,
  address2_in DS3.CUSTOMERS3.ADDRESS2%TYPE,
  city_in DS3.CUSTOMERS3.CITY%TYPE,
  state_in DS3.CUSTOMERS3.STATE%TYPE,
  zip_in DS3.CUSTOMERS3.ZIP%TYPE,
  country_in DS3.CUSTOMERS3.COUNTRY%TYPE,
  region_in DS3.CUSTOMERS3.REGION%TYPE,
  email_in DS3.CUSTOMERS3.EMAIL%TYPE,
  phone_in DS3.CUSTOMERS3.PHONE%TYPE,
  creditcardtype_in DS3.CUSTOMERS3.CREDITCARDTYPE%TYPE,
  creditcard_in DS3.CUSTOMERS3.CREDITCARD%TYPE,
  creditcardexpiration_in DS3.CUSTOMERS3.CREDITCARDEXPIRATION%TYPE,
  username_in DS3.CUSTOMERS3.USERNAME%TYPE,
  password_in DS3.CUSTOMERS3.PASSWORD%TYPE,
  age_in DS3.CUSTOMERS3.AGE%TYPE,
  income_in DS3.CUSTOMERS3.INCOME%TYPE,
  gender_in DS3.CUSTOMERS3.GENDER%TYPE,
  customerid_out OUT INTEGER
  )
  IS
  rows_returned INTEGER;
  BEGIN

    SELECT COUNT(*) INTO rows_returned FROM CUSTOMERS3 WHERE USERNAME = username_in;

    IF rows_returned = 0
    THEN
      SELECT CUSTOMERID_SEQ3.NEXTVAL INTO customerid_out FROM DUAL;
      INSERT INTO CUSTOMERS3
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

    END NEW_CUSTOMER3;
/

CREATE OR REPLACE  PROCEDURE "DS3"."NEW_MEMBER3"
  (
  customerid_in INTEGER,
  membershiplevel_in INTEGER,
  customerid_out OUT INTEGER
  )
  IS
  rows_returned INTEGER;
  BEGIN

    SELECT COUNT(*) INTO rows_returned FROM MEMBERSHIP3 WHERE CUSTOMERID = customerid_in;

    IF rows_returned = 0
    THEN
      INSERT INTO MEMBERSHIP3
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
    END NEW_MEMBER3;
/




CREATE OR REPLACE PROCEDURE "DS3"."NEW_PROD_REVIEW3"
  (
  prod_id_in 		IN DS3.REVIEWS3.PROD_ID%TYPE,
  stars_in 		IN DS3.REVIEWS3.STARS%TYPE,
  customerid_in 	IN DS3.REVIEWS3.CUSTOMERID%TYPE,
  review_summary_in 	IN DS3.REVIEWS3.REVIEW_SUMMARY%TYPE,
  review_text_in 	IN DS3.REVIEWS3.REVIEW_TEXT%TYPE,
  review_id_out 	OUT INTEGER
 )
  IS
  rows_returned INTEGER;
  BEGIN

      SELECT REVIEWID_SEQ3.NEXTVAL INTO review_id_out FROM DUAL;
      INSERT INTO REVIEWS3
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
END NEW_PROD_REVIEW3; 
/

CREATE OR REPLACE PROCEDURE "DS3"."NEW_REVIEW_HELPFULNESS3"
  (
  review_id_in          	IN DS3.REVIEWS_HELPFULNESS3.REVIEW_ID%TYPE,
  customerid_in         	IN DS3.REVIEWS_HELPFULNESS3.CUSTOMERID%TYPE,
  review_helpfulness_in 	IN DS3.REVIEWS_HELPFULNESS3.HELPFULNESS%TYPE,
  review_helpfulness_id_out     OUT INTEGER
 )
  IS
  rows_returned INTEGER;
  BEGIN

      SELECT REVIEWHELPFULNESSID_SEQ3.NEXTVAL INTO review_helpfulness_id_out FROM DUAL;
      INSERT INTO REVIEWS_HELPFULNESS3
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
END NEW_REVIEW_HELPFULNESS3;
/


CREATE OR REPLACE  PROCEDURE "DS3"."LOGIN3" 
  (
  username_in        IN  DS3.CUSTOMERS3.USERNAME%TYPE,
  password_in        IN  DS3.CUSTOMERS3.PASSWORD%TYPE,
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
    
    SELECT CUSTOMERID INTO customerid_out FROM CUSTOMERS3 WHERE USERNAME = username_in AND PASSWORD = password_in;
    
    delete from derivedtable13;

    insert into derivedtable13 select products3.title, products3.actor, products3.prod_id, products3.common_prod_id
        from cust_hist3 inner join products3 on cust_hist3.prod_id = products3.prod_id
       where (cust_hist3.customerid = customerid_out);
    OPEN result_cv FOR
      SELECT derivedtable13.TITLE, derivedtable13.ACTOR, PRODUCTS3.TITLE AS RelatedTitle
        FROM
          derivedtable13 INNER JOIN
            PRODUCTS3 ON derivedtable13.COMMON_PROD_ID = PRODUCTS3.PROD_ID;
    
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
  
  END LOGIN3;
/


CREATE OR REPLACE PROCEDURE "DS3"."BROWSE_BY_CATEGORY3" 
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
      SELECT * FROM PRODUCTS3 WHERE CATEGORY = category_in AND SPECIAL = 1;
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
  END BROWSE_BY_CATEGORY3;
/  


CREATE OR REPLACE PROCEDURE "DS3"."BROWSE_BY_CAT_FOR_MEMBERTY3"
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
      SELECT * FROM PRODUCTS3 WHERE CATEGORY = category_in AND SPECIAL = 1 AND MEMBERSHIP_ITEM <= membershiptype_in;
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
  END BROWSE_BY_CAT_FOR_MEMBERTY3;
/



CREATE OR REPLACE PROCEDURE GET_PROD_REVIEWS3
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
        (SELECT reviews3.prod_id, reviews3.review_id, reviews_helpfulness3.helpfulness, reviews3.stars FROM
        reviews3 INNER JOIN reviews_helpfulness3 ON reviews3.review_id=reviews_helpfulness3.review_id WHERE 
        reviews3.prod_id = prod_in))
        GROUP BY review_id ORDER BY sum(helpfulness) DESC)
      SELECT s1.review_id, reviews3.prod_id, reviews3.review_date, reviews3.stars, reviews3.customerid, reviews3.review_summary, reviews3.review_text, s1.total FROM
      s1 INNER JOIN reviews3 on reviews3.review_id=s1.review_id;
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

  END GET_PROD_REVIEWS3;
/

  
CREATE OR REPLACE  PROCEDURE "DS3"."GET_PROD_REVIEWS_BY_STARS3"
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
        (SELECT reviews3.prod_id, reviews3.review_id, reviews_helpfulness3.helpfulness, reviews3.stars FROM
        reviews3 INNER JOIN reviews_helpfulness3 ON reviews3.review_id=reviews_helpfulness3.review_id WHERE 
        reviews3.prod_id = prod_in)WHERE stars = stars_in)
        GROUP BY review_id ORDER BY sum(helpfulness) DESC)
      SELECT s1.review_id, reviews3.prod_id, reviews3.review_date, reviews3.stars, reviews3.customerid, reviews3.review_summary, reviews3.review_text, s1.total FROM
      s1 INNER JOIN reviews3 on reviews3.review_id=s1.review_id;
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

  END GET_PROD_REVIEWS_BY_STARS3;
/


CREATE OR REPLACE  PROCEDURE "DS3"."GET_PROD_REVIEWS_BY_DATE3"
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
      SELECT * FROM REVIEWS3 WHERE PROD_ID = prod_in ORDER BY REVIEW_DATE DESC;
    END IF;

    found := 0;
    FOR i IN 1..batch_size LOOP
      FETCH result_cv INTO review_id_out(i), prod_id_out(i), review_date_out(i), review_stars_out(i), review_customerid_out(i), review_summary_out(i), review_text_out(i);
      SELECT SUM(helpfulness) INTO review_helpfulness_sum_out(i) from reviews_helpfulness3 where REVIEW_ID = review_id_out(i);
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

  END GET_PROD_REVIEWS_BY_DATE3;
/


CREATE OR REPLACE  PROCEDURE "DS3"."GET_PROD_REVIEWS_BY_ACTOR3"
  (
   batch_size                  IN INTEGER,
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
          (SELECT PRODUCTS3.TITLE, PRODUCTS3.ACTOR, PRODUCTS3.PROD_ID, REVIEWS3.REVIEW_DATE, REVIEWS3.STARS, REVIEWS3.REVIEW_ID,
           REVIEWS3.CUSTOMERID, REVIEWS3.REVIEW_SUMMARY, REVIEWS3.REVIEW_TEXT 
           FROM PRODUCTS3 INNER JOIN REVIEWS3 on PRODUCTS3.PROD_ID = REVIEWS3.PROD_ID where CONTAINS (ACTOR, actor_in) > 0 AND ROWNUM<=10 )
         select T1.title, T1.actor, T1.REVIEW_ID, T1.prod_id, T1.review_date, T1.stars, 
                T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS3 
         inner join T1 on REVIEWS_HELPFULNESS3.REVIEW_ID = T1.review_id
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
  END GET_PROD_REVIEWS_BY_ACTOR3;
/


CREATE OR REPLACE  PROCEDURE "DS3"."GET_PROD_REVIEWS_BY_TITLE3"
  (
   batch_size                  IN INTEGER,
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
          (SELECT PRODUCTS3.TITLE, PRODUCTS3.ACTOR, PRODUCTS3.PROD_ID, REVIEWS3.REVIEW_DATE, REVIEWS3.STARS, REVIEWS3.REVIEW_ID,
           REVIEWS3.CUSTOMERID, REVIEWS3.REVIEW_SUMMARY, REVIEWS3.REVIEW_TEXT
           FROM PRODUCTS3 INNER JOIN REVIEWS3 on PRODUCTS3.PROD_ID = REVIEWS3.PROD_ID where CONTAINS (TITLE, title_in) > 0 AND ROWNUM<=10 )
         select T1.title, T1.actor, T1.REVIEW_ID, T1.prod_id, T1.review_date, T1.stars,
                T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS3
         inner join T1 on REVIEWS_HELPFULNESS3.REVIEW_ID = T1.review_id
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
  END GET_PROD_REVIEWS_BY_TITLE3;
/




CREATE OR REPLACE  PROCEDURE "DS3"."BROWSE_BY_ACTOR3"
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
      SELECT * FROM PRODUCTS3 WHERE CONTAINS(ACTOR, actor_in) > 0;
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
  END BROWSE_BY_ACTOR3;
/


CREATE OR REPLACE  PROCEDURE "DS3"."BROWSE_BY_ACTOR_FOR_MEMBERTY3"
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
      SELECT * FROM PRODUCTS3 WHERE CONTAINS(ACTOR, actor_in) > 0 AND MEMBERSHIP_ITEM <= membershiptype_in;
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
  END BROWSE_BY_ACTOR_FOR_MEMBERTY3;
/

  
  
CREATE OR REPLACE  PROCEDURE "DS3"."BROWSE_BY_TITLE3"
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
      SELECT * FROM PRODUCTS3 WHERE CONTAINS(TITLE, title_in) > 0;
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
  END BROWSE_BY_TITLE3;
/
 

CREATE OR REPLACE  PROCEDURE "DS3"."BROWSE_BY_TITLE_FOR_MEMBERTY3"
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
      SELECT * FROM PRODUCTS3 WHERE CONTAINS(TITLE, title_in) > 0 AND MEMBERSHIP_ITEM <= membershiptype_in;
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
  END BROWSE_BY_TITLE_FOR_MEMBERTY3;
/


 
  
CREATE OR REPLACE  PROCEDURE "DS3"."PURCHASE3"
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

    SELECT ORDERID_SEQ3.NEXTVAL INTO neworderid_out FROM DUAL;

    date_in := SYSDATE;
--  date_in := TO_DATE('2005/1/1', 'YYYY/MM/DD');

    COMMIT;

  -- Start Transaction
    SET TRANSACTION NAME 'FillOrder';

  

  -- CREATE NEW ENTRY IN ORDERS TABLE
    INSERT INTO ORDERS3
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
      INSERT INTO ORDERLINES3
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
      SELECT QUAN_IN_STOCK, SALES into cur_quan, cur_sales FROM INVENTORY3 WHERE PROD_ID=prod_id_in(item_id);
      new_quan := cur_quan - qty_in(item_id);
      new_sales := cur_sales + qty_in(item_id);
      IF new_quan < 0 THEN
        ROLLBACK;
        neworderid_out := 0;
        RETURN;
      ELSE
        IF new_quan < 3 THEN  -- this is kluge to keep rollback rate constant - assumes 1, 2 or 3 quan ordered
          UPDATE INVENTORY3 SET SALES= new_sales WHERE PROD_ID=prod_id_in(item_id);
        ELSE
          UPDATE INVENTORY3 SET QUAN_IN_STOCK = new_quan, SALES= new_sales WHERE PROD_ID=prod_id_in(item_id);
        END IF;
        INSERT INTO CUST_HIST3
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

  END PURCHASE3;
/

CREATE OR REPLACE TRIGGER "DS3"."RESTOCK3" 
AFTER UPDATE OF "QUAN_IN_STOCK" ON "DS3"."INVENTORY3" 
FOR EACH ROW WHEN (NEW.QUAN_IN_STOCK < 10) 

DECLARE
  X NUMBER;
BEGIN 
  SELECT COUNT(*) INTO X FROM DS3.REORDER3 WHERE PROD_ID = :NEW.PROD_ID;
  IF x = 0 THEN
    INSERT INTO DS3.REORDER3(PROD_ID, DATE_LOW, QUAN_LOW) VALUES(:NEW.PROD_ID, SYSDATE, :NEW.QUAN_IN_STOCK);
  END IF;
END RESTOCK3;
/


exit;
