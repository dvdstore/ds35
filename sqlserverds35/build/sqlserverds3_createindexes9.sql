USE DS3
GO

ALTER TABLE CATEGORIES9 ADD CONSTRAINT PK_CATEGORIES9 PRIMARY KEY CLUSTERED 
  (
  CATEGORY
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE CUSTOMERS9 ADD CONSTRAINT PK_CUSTOMERS9 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_CUST_FG 
GO

CREATE UNIQUE INDEX IX_CUST_UN_PW9 ON CUSTOMERS9 
  (
  USERNAME, 
  PASSWORD
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID9 ON CUST_HIST9
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID9 ON CUST_HIST9 
  (
  CUSTOMERID ASC,
  PROD_ID ASC
  )
  ON DS_IND_FG
GO

ALTER TABLE CUST_HIST9
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID9 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS9 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE ORDERS9 ADD CONSTRAINT PK_ORDERS9 PRIMARY KEY CLUSTERED 
  (
  ORDERID
  )  
  ON DS_ORDERS_FG 
GO

CREATE INDEX IX_ORDER_CUSTID9 ON ORDERS9
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

ALTER TABLE ORDERLINES9 ADD CONSTRAINT PK_ORDERLINES9 PRIMARY KEY CLUSTERED 
  (
  ORDERID,
  ORDERLINEID
  )  
  ON DS_ORDERS_FG 
GO

ALTER TABLE ORDERLINES9 ADD CONSTRAINT FK_ORDERID9 FOREIGN KEY (ORDERID)
  REFERENCES ORDERS9 (ORDERID)
  ON DELETE CASCADE
GO

ALTER TABLE INVENTORY9 ADD CONSTRAINT PK_INVENTORY9 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE PRODUCTS9 ADD CONSTRAINT PK_PRODUCTS9 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

CREATE INDEX IX_PROD_PRODID9 ON PRODUCTS9 
  (
  PROD_ID ASC
  )
  INCLUDE (TITLE)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_PRODID_COMMON_PRODID9 ON PRODUCTS9
  (
  PROD_ID ASC,
  COMMON_PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL_CATEGORY_PRODID9 ON PRODUCTS9 
  (
  SPECIAL ASC,
  CATEGORY ASC,
  PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR, PRICE, COMMON_PROD_ID)
  ON DS_IND_FG
GO

CREATE FULLTEXT CATALOG FULLTEXT_DSPROD9 ON FILEGROUP DS_FULLTEXT_FG;
GO
CREATE FULLTEXT INDEX ON PRODUCTS9
	( 
	ACTOR,
	TITLE
	)
	KEY INDEX PK_PRODUCTS9 
	ON FULLTEXT_DSPROD9;
GO

CREATE INDEX IX_PROD_CATEGORY9 ON PRODUCTS9 
  (
  CATEGORY
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL9 ON PRODUCTS9
  (
  SPECIAL
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_MEMBERSHIP9 ON PRODUCTS9
  (
  MEMBERSHIP_ITEM
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_INV_PROD_ID9 on INVENTORY9
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

ALTER TABLE MEMBERSHIP9 ADD CONSTRAINT PK_MEMBERSHIP9 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_IND_FG 
GO

ALTER TABLE MEMBERSHIP9
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID9 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS9 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS9 ADD CONSTRAINT PK_REVIEWS9 PRIMARY KEY CLUSTERED 
  (
  REVIEW_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS9
  ADD CONSTRAINT FK_REVIEWS_PROD_ID9 FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS9 (PROD_ID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS9
  ADD CONSTRAINT FK_REVIEWS_CUSTOMERID9 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS9 (CUSTOMERID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_PROD_ID9 ON REVIEWS9
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_STARS9 ON REVIEWS9
  (
  STARS
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_PRODSTARS9 ON REVIEWS9
  (
  PROD_ID,STARS
  )
  ON DS_IND_FG
GO

ALTER TABLE REVIEWS_HELPFULNESS9 ADD CONSTRAINT PK_REVIEWS_HELPFULNESS9 PRIMARY KEY CLUSTERED 
  (
  REVIEW_HELPFULNESS_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS_HELPFULNESS9
  ADD CONSTRAINT FK_REVIEW_ID9 FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS9 (REVIEW_ID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_HELP_REVID9 ON REVIEWS_HELPFULNESS9
  (
  REVIEW_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_HELP_CUSTID9 ON REVIEWS_HELPFULNESS9
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REORDER_PRODID9 ON REORDER9
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE NONCLUSTERED INDEX IX_REVIEWS_PRODID_REVID_DATE9 ON REVIEWS9
  (
  PROD_ID ASC,
  REVIEW_ID ASC,
  REVIEW_DATE ASC
  )
  INCLUDE (STARS,CUSTOMERID,REVIEW_SUMMARY,REVIEW_TEXT)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go

CREATE NONCLUSTERED INDEX IX_REVIEWSHELPFULNESS_ID_HELPID9 ON [dbo].[REVIEWS_HELPFULNESS9]
  (
  REVIEW_ID ASC,
  REVIEW_HELPFULNESS_ID ASC
  )
  INCLUDE (HELPFULNESS)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go



CREATE STATISTICS stat_cust_cctype_username9 ON CUSTOMERS9(CREDITCARDTYPE, USERNAME)
GO
CREATE STATISTICS stat_cust_cctype_customerid9 ON CUSTOMERS9(CREDITCARDTYPE, CUSTOMERID)
GO
CREATE STATISTICS stat_prod_prodid_special9 ON PRODUCTS9(PROD_ID, SPECIAL)
GO
CREATE STATISTICS stat_prod_category_prodid9 ON PRODUCTS9(CATEGORY, PROD_ID)
GO
CREATE STATISTICS stat_reviews_reviewid_stars9 ON REVIEWS9(REVIEW_ID, STARS)
GO
CREATE STATISTICS stat_reviews_prodid_custid9 ON REVIEWS9(PROD_ID, CUSTOMERID)
GO
CREATE STATISTICS stat_reviews_reviewid_date9 ON REVIEWS9(REVIEW_ID, REVIEW_DATE)
GO
CREATE STATISTICS stat_reviews_date_prodid9 ON REVIEWS9(REVIEW_DATE, PROD_ID)
GO
CREATE STATISTICS stat_reviews_prodid_stars_reviewid9 ON REVIEWS9(PROD_ID, STARS, REVIEW_ID)
GO
  
