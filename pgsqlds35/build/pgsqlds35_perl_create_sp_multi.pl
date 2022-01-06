# pgsqlds35_perl_create_sp_multi.pl
# Script to create a ds35 stored procedures in PostgresQL with a provided number of copies - supporting multiple stores
# Syntax to run - perl pgsqlds35_perl_create_sp_multi.pl <psql_target> <number_of_stores>

use strict;
use warnings;

my $pgsql_target = $ARGV[0];
my $numStores = $ARGV[1];
my $PGPASSWORD = "ds3";
my $DBNAME = "ds3";
my $SYSDBA = "ds3";

foreach my $k (1 .. $numStores){
	open(my $OUT, ">pgsqlds35_createsp.sql") || die("Can't open pgsqlds35_createsp.sql");
	print $OUT "
\\c $DBNAME;

CREATE OR REPLACE FUNCTION new_customer$k (
    IN firstname_in VARCHAR(50),
    IN lastname_in VARCHAR(50),
    IN address1_in VARCHAR(50),
    IN address2_in VARCHAR(50),
    IN city_in VARCHAR(50),
    IN state_in VARCHAR(50),
    IN zip_in VARCHAR(9),
    IN country_in VARCHAR(50),
    IN region_in SMALLINT,
    IN email_in VARCHAR(50),
    IN phone_in VARCHAR(50),
    IN creditcardtype_in int,
    IN creditcard_in VARCHAR(50),
    IN creditcardexpiration_in VARCHAR(50),
    IN username_in VARCHAR(50),
    IN password_in VARCHAR(50),
    IN age_in SMALLINT,
    IN income_in int,
    IN gender_in VARCHAR(1)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS \$\$
DECLARE
    customerid_out INTEGER;
    age_int INTEGER;
    income_int INTEGER;
BEGIN
    -- IF age_in = '' THEN age_int:=0 ; ELSE age_int := CAST (age_in AS INT); END IF;
    -- IF income_in = '' THEN income_int:=0; ELSE income_int := CAST (income_in AS INT); END IF;
    BEGIN
    INSERT INTO CUSTOMERS$k (
          firstname,
          lastname,
          email,
          phone,
          username,
          password,
          address1,
          address2,
          city,
          state,
          zip,
          country,
          region,
          creditcardtype,
          creditcard,
          creditcardexpiration,
          age,
          income,
          gender
    )
    VALUES (
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
          age_int,
	  income_int,
	  gender_in
    )
    RETURNING customerid INTO customerid_out;
    RETURN customerid_out;
    EXCEPTION
    	WHEN unique_violation THEN
            RETURN 0;
    END;
    -- RETURN -1;
END;
\$\$
;

CREATE OR REPLACE FUNCTION login$k (
    IN username_in text,
    IN password_in text

)
RETURNS TABLE (r_customerid int, r_title text, r_actor text, r_relatedpurchase text)
LANGUAGE plpgsql
AS \$\$
DECLARE
    customerid_out INT;
BEGIN
    SELECT CUSTOMERID INTO customerid_out FROM CUSTOMERS$k WHERE USERNAME=username_in AND PASSWORD=password_in;
    IF FOUND THEN
      If EXISTS (    -- Check to see if there are any related purchases to recommend for user
            SELECT derivedtable1.CUSTOMERID, derivedtable1.TITLE, derivedtable1.ACTOR, PRODUCTS_1.TITLE
        AS RelatedPurchase FROM (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR,
          PRODUCTS$k.PROD_ID, PRODUCTS$k.COMMON_PROD_ID, CUST_HIST$k.CUSTOMERID
        FROM CUST_HIST$k INNER JOIN PRODUCTS$k ON CUST_HIST$k.PROD_ID =  PRODUCTS$k.PROD_ID
        WHERE (CUST_HIST$k.CUSTOMERID = customerid_out)) AS derivedtable1
        INNER JOIN PRODUCTS$k AS PRODUCTS_1 ON derivedtable1.COMMON_PROD_ID = PRODUCTS_1.PROD_ID
            )
            THEN
            RETURN QUERY     -- Run query and return results with the related purchases
                  SELECT derivedtable1.CUSTOMERID, derivedtable1.TITLE, derivedtable1.ACTOR, PRODUCTS_1.TITLE
          AS RelatedPurchase FROM (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR,
           PRODUCTS$k.PROD_ID, PRODUCTS$k.COMMON_PROD_ID, CUST_HIST$k.CUSTOMERID
          FROM CUST_HIST$k INNER JOIN PRODUCTS$k ON CUST_HIST$k.PROD_ID =  PRODUCTS$k.PROD_ID
          WHERE (CUST_HIST$k.CUSTOMERID = customerid_out)ORDER BY ORDERID DESC, TITLE ASC LIMIT 10) AS derivedtable1
          INNER JOIN PRODUCTS$k AS PRODUCTS_1 ON derivedtable1.COMMON_PROD_ID = PRODUCTS_1.PROD_ID;
             ELSE
                   RETURN QUERY SELECT * FROM (VALUES (customerid_out,'None','None','None'))  -- return customer id incase of no related purchases found
                   AS RETURNLOGIN(custid_out,actor,title,relateditem);
                END IF;
    ELSE
          RETURN QUERY SELECT * FROM (VALUES (0,'None','None','None'))
          AS RETURNLOGIN(custid_out,actor,title,relateditem); -- return customerid of 0 to indicate that login failed - user not found
    END IF;
   RETURN;
END;
\$\$;


CREATE OR REPLACE FUNCTION BROWSE_BY_CATEGORY$k (
    IN batch_size_in INTEGER,
    IN category_in INTEGER
)
RETURNS SETOF PRODUCTS$k
LANGUAGE plpgsql
AS \$\$
BEGIN
    RETURN QUERY SELECT * FROM PRODUCTS$k WHERE CATEGORY=category_in AND SPECIAL=1 LIMIT batch_size_in;
    RETURN;
END;
\$\$;


CREATE OR REPLACE FUNCTION BROWSE_BY_ACTOR$k(
    IN batch_size_in INTEGER,
    IN actor_in TEXT
)
RETURNS SETOF PRODUCTS$k
LANGUAGE plpgsql
AS \$\$
DECLARE
  vector_in TEXT;
BEGIN
    vector_in := replace(trim(both from actor_in), ' ','&');
    RETURN QUERY SELECT * FROM PRODUCTS$k WHERE to_tsvector('simple',ACTOR) \@\@ to_tsquery(vector_in) LIMIT batch_size_in;
    RETURN;
END;
\$\$;


CREATE OR REPLACE FUNCTION BROWSE_BY_TITLE$k (
    IN batch_size_in INTEGER,
    IN title_in TEXT
)
RETURNS SETOF PRODUCTS$k
LANGUAGE plpgsql
AS \$\$
DECLARE
  vector_in TEXT;
BEGIN
    vector_in := replace(trim(both from title_in), ' ','&');
    RETURN QUERY SELECT * FROM PRODUCTS$k WHERE to_tsvector('simple',TITLE) \@\@ to_tsquery(vector_in) LIMIT batch_size_in;
    RETURN;
END;
\$\$;


CREATE OR REPLACE FUNCTION PURCHASE$k (
    IN customerid_in INTEGER,
    IN number_items INTEGER,
    IN netamount_in NUMERIC,
    IN taxamount_in NUMERIC,
    IN totalamount_in NUMERIC,
    IN prod_id_in0 INTEGER DEFAULT 0, IN qty_in0 INTEGER DEFAULT 0,
    IN prod_id_in1 INTEGER DEFAULT 0, IN qty_in1 INTEGER DEFAULT 0,
    IN prod_id_in2 INTEGER DEFAULT 0, IN qty_in2 INTEGER DEFAULT 0,
    IN prod_id_in3 INTEGER DEFAULT 0, IN qty_in3 INTEGER DEFAULT 0,
    IN prod_id_in4 INTEGER DEFAULT 0, IN qty_in4 INTEGER DEFAULT 0,
    IN prod_id_in5 INTEGER DEFAULT 0, IN qty_in5 INTEGER DEFAULT 0,
    IN prod_id_in6 INTEGER DEFAULT 0, IN qty_in6 INTEGER DEFAULT 0,
    IN prod_id_in7 INTEGER DEFAULT 0, IN qty_in7 INTEGER DEFAULT 0,
    IN prod_id_in8 INTEGER DEFAULT 0, IN qty_in8 INTEGER DEFAULT 0,
    IN prod_id_in9 INTEGER DEFAULT 0, IN qty_in9 INTEGER DEFAULT 0
)
RETURNS INTEGER
LANGUAGE plpgsql
AS \$\$
DECLARE
  date_in TIMESTAMP;
  neworderid INTEGER;
  item_id    INTEGER;
  prodid    INTEGER;
  qty        INTEGER;
  cur_quan   INTEGER;
  new_quan   INTEGER;
  cur_sales  INTEGER;
  new_sales  INTEGER;
BEGIN
 date_in := current_timestamp;
 BEGIN
   INSERT INTO ORDERS$k
    (
    ORDERDATE, CUSTOMERID, NETAMOUNT, TAX, TOTALAMOUNT
    )
  VALUES
  (
    date_in, customerid_in, netamount_in, taxamount_in, totalamount_in
    )
    RETURNING orderid INTO neworderid;


  -- neworderid := CURRVAL('orders_orderid_seq');


  -- ADD LINE ITEMS TO ORDERLINES

  item_id := 0;

  WHILE (item_id < number_items) LOOP
    prodid := CASE item_id WHEN 0 THEN prod_id_in0
                                  WHEN 1 THEN prod_id_in1
                                  WHEN 2 THEN prod_id_in2
                                  WHEN 3 THEN prod_id_in3
                                  WHEN 4 THEN prod_id_in4
                                  WHEN 5 THEN prod_id_in5
                                  WHEN 6 THEN prod_id_in6
                                  WHEN 7 THEN prod_id_in7
                                  WHEN 8 THEN prod_id_in8
                                  WHEN 9 THEN prod_id_in9
                      END;

    qty := CASE item_id WHEN 0 THEN qty_in0
                                    WHEN 1 THEN qty_in1
                                    WHEN 2 THEN qty_in2
                                    WHEN 3 THEN qty_in3
                                    WHEN 4 THEN qty_in4
                                    WHEN 5 THEN qty_in5
                                    WHEN 6 THEN qty_in6
                                    WHEN 7 THEN qty_in7
                                    WHEN 8 THEN qty_in8
                                    WHEN 9 THEN qty_in9
                        END;

    SELECT QUAN_IN_STOCK, SALES  INTO cur_quan, cur_sales FROM INVENTORY$k WHERE PROD_ID=prodid;
    new_quan := cur_quan - qty;
    new_sales := cur_Sales + qty;

    IF (new_quan < 0) THEN
        -- RAISE EXCEPTION 'Insufficient Quantity for prodid:%' , prodid;
        RETURN 0;
    ELSE
        UPDATE INVENTORY$k SET QUAN_IN_STOCK=new_quan, SALES=new_sales WHERE PROD_ID=prodid;
        INSERT INTO ORDERLINES$k
          (
          ORDERLINEID, ORDERID, PROD_ID, QUANTITY, ORDERDATE
          )
        VALUES
          (
          item_id + 1, neworderid, prodid, qty, date_in
          );

        INSERT INTO CUST_HIST$k
          (
          CUSTOMERID, ORDERID, PROD_ID
          )
        VALUES
          (
          customerid_in, neworderid, prodid
          );

        item_id := item_id + 1;
     END IF;
  END LOOP;
  RETURN neworderid;
 END;
END;
\$\$;





CREATE OR REPLACE FUNCTION new_member$k (
  IN customerid_in INT,
  IN membershiplevel_in INT

  )
  RETURNS INTEGER
  LANGUAGE plpgsql
  AS \$\$
  DECLARE
    customerid_out INTEGER;
  BEGIN
    BEGIN
      INSERT INTO MEMBERSHIP$k
        (CUSTOMERID,
         MEMBERSHIPTYPE,
         EXPIREDATE
         )
       VALUES
         (
         customerid_in,
         membershiplevel_in,
         current_date
         )
       RETURNING customerid INTO customerid_out;
           RETURN customerid_out;
           EXCEPTION
             WHEN unique_violation THEN
                RETURN 0;
       END;
 END;
 \$\$;

CREATE OR REPLACE FUNCTION new_prod_review$k
  (
  IN prod_id_in INT,
  IN stars_in INT,
  IN customerid_in INT,
  IN review_summary_in TEXT,
  IN review_text_in TEXT
  )
  RETURNS INTEGER
  LANGUAGE plpgsql
  AS \$\$
  DECLARE
    review_id_out INTEGER;
  BEGIN
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
        prod_id_in,
            current_date,
        stars_in,
        customerid_in,
        review_summary_in,
        review_text_in
        )
                RETURNING review_id INTO review_id_out;
        RETURN review_id_out;
      COMMIT;
END;
\$\$;

CREATE OR REPLACE FUNCTION new_review_helpfulness$k
  (
  IN review_id_in INT,
  IN customerid_in INT,
  IN review_helpfulness_in INT
  )
  RETURNS INTEGER
  LANGUAGE plpgsql
  AS \$\$
  DECLARE
    review_helpfulness_id_out INT;
  BEGIN
    INSERT INTO REVIEWS_HELPFULNESS$k
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
                RETURNING REVIEW_HELPFULNESS_ID INTO review_helpfulness_id_out;
      RETURN review_helpfulness_id_out;
          COMMIT;
END;
\$\$;

CREATE OR REPLACE FUNCTION get_prod_reviews$k
(
   IN batch_size_in INT,
   IN prod_in INT
  )
  RETURNS TABLE (r_review_id int, r_prod_id int, r_review_date date, r_stars smallint,
                                 r_customerid int, r_review_summary text, r_review_text text, r_totalhelp bigint)
  LANGUAGE plpgsql
  AS
  \$\$
BEGIN
  RETURN QUERY
  SELECT REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID,
  REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT, SUM(REVIEWS_HELPFULNESS$k.helpfulness) as total
  FROM REVIEWS$k
  INNER JOIN REVIEWS_HELPFULNESS$k on REVIEWS$k.REVIEW_ID=REVIEWS_HELPFULNESS$k.REVIEW_ID
  WHERE REVIEWS$k.PROD_ID = prod_in GROUP BY REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE,
  REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
  ORDER BY total DESC LIMIT batch_size_in;
  RETURN;
 END;
 \$\$;

 CREATE OR REPLACE FUNCTION get_prod_reviews_by_stars$k
  (
   IN batch_size_in INT,
   IN prod_in INT,
   IN stars_in INT
   )
   RETURNS TABLE (r_review_id int, r_prod_id int, r_review_date date, r_stars smallint,
                                 r_customerid int, r_review_summary text, r_review_text text, r_totalhelp bigint)
   LANGUAGE plpgsql
   AS
   \$\$
  BEGIN
  RETURN QUERY
    SELECT REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID,
    REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT, SUM(REVIEWS_HELPFULNESS$k.helpfulness) as total
    FROM REVIEWS$k
    INNER JOIN REVIEWS_HELPFULNESS$k on REVIEWS$k.REVIEW_ID=REVIEWS_HELPFULNESS$k.REVIEW_ID
    WHERE REVIEWS$k.PROD_ID = \@prod_in AND REVIEWS$k.STARS = \@stars_in GROUP BY REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE,
    REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
    ORDER BY total DESC LIMIT batch_size_in;
        RETURN;
  END;
  \$\$;


CREATE OR REPLACE FUNCTION get_prod_reviews_by_date$k
  (
   IN batch_size_in INT,
   IN prod_in INT
   )
   RETURNS TABLE (r_review_id int, r_prod_id int, r_review_date date, r_stars smallint,
                                 r_customerid int, r_review_summary text, r_review_text text, r_totalhelp bigint)
   LANGUAGE plpgsql
   AS
   \$\$
  BEGIN
  RETURN QUERY
    SELECT REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID,
    REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT, SUM(REVIEWS_HELPFULNESS$k.helpfulness) as total
    FROM REVIEWS$k
    INNER JOIN REVIEWS_HELPFULNESS$k on REVIEWS$k.REVIEW_ID=REVIEWS_HELPFULNESS$k.REVIEW_ID
    WHERE REVIEWS$k.PROD_ID = \@prod_in GROUP BY REVIEWS$k.REVIEW_ID, REVIEWS$k.PROD_ID, REVIEWS$k.REVIEW_DATE,
    REVIEWS$k.STARS, REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
    ORDER BY REVIEWS$k.REVIEW_DATE DESC LIMIT batch_size_in;
    RETURN;
  END;
  \$\$;


  CREATE OR REPLACE FUNCTION get_prod_reviews_by_actor$k
  (
   IN batch_size_in INT,
   IN actor_in TEXT
  )
  RETURNS TABLE (r_prod_id int, r_title text, r_actor text, r_review_id int, r_review_date date, r_stars smallint,
                                 r_customerid int, r_review_summary text, r_review_text text, r_totalhelp bigint)
  LANGUAGE plpgsql
  AS
  \$\$
  DECLARE
    vector_in TEXT;
  BEGIN
    vector_in := replace(trim(both from actor_in), ' ','&');
        RETURN QUERY
    WITH T1 AS (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.REVIEW_ID,
           REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
           FROM PRODUCTS$k INNER JOIN REVIEWS$k on PRODUCTS$k.PROD_ID = REVIEWS$k.PROD_ID where to_tsvector('simple',ACTOR) \@\@ to_tsquery(vector_in) limit 500)
    select T1.prod_id, T1.title, T1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, T1.review_date, T1.stars,
           T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS$k
           inner join T1 on REVIEWS_HELPFULNESS$k.REVIEW_ID = T1.review_id
                   GROUP BY T1.REVIEW_ID, T1.prod_id, t1.title, t1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, t1.review_date, t1.stars, t1.customerid, t1.review_summary, t1.review_text
                   ORDER BY totalhelp DESC limit batch_size_in;
        RETURN;
  END;
  \$\$;

CREATE OR REPLACE FUNCTION get_prod_reviews_by_title$k
  (
   IN batch_size_in INT,
   IN title_in TEXT
   )
   RETURNS TABLE (r_prod_id int, r_title text, r_actor text, r_review_id int, r_review_date date, r_stars smallint,
                                 r_customerid int, r_review_summary text, r_review_text text, r_totalhelp bigint)
   LANGUAGE plpgsql
   AS
   \$\$
   DECLARE
     vector_in TEXT;
   BEGIN
    vector_in := replace(trim(both from title_in), ' ','&');
        RETURN QUERY
    WITH T1 AS (SELECT PRODUCTS$k.TITLE, PRODUCTS$k.ACTOR, PRODUCTS$k.PROD_ID, REVIEWS$k.REVIEW_DATE, REVIEWS$k.STARS, REVIEWS$k.REVIEW_ID,
           REVIEWS$k.CUSTOMERID, REVIEWS$k.REVIEW_SUMMARY, REVIEWS$k.REVIEW_TEXT
           FROM PRODUCTS$k INNER JOIN REVIEWS$k on PRODUCTS$k.PROD_ID = REVIEWS$k.PROD_ID where to_tsvector('simple',TITLE) \@\@ to_tsquery(vector_in) limit 500)
    select T1.prod_id, T1.title, T1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, T1.review_date, T1.stars,
           T1.customerid, T1.review_summary, T1.review_text, SUM(helpfulness) AS totalhelp from REVIEWS_HELPFULNESS$k
           inner join T1 on REVIEWS_HELPFULNESS$k.REVIEW_ID = T1.review_id
                   GROUP BY T1.REVIEW_ID, T1.prod_id, t1.title, t1.actor, REVIEWS_HELPFULNESS$k.REVIEW_ID, t1.review_date, t1.stars, t1.customerid, t1.review_summary, t1.review_text
                   ORDER BY totalhelp DESC limit batch_size_in;
        RETURN;
  END;
  \$\$;


\n";
	close $OUT;
	sleep(1);
	print("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < pgsqlds35_createsp.sql\n");
        system("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < pgsqlds35_createsp.sql");
}
