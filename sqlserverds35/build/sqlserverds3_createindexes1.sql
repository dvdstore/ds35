USE DS3
GO

ALTER TABLE CATEGORIES1 ADD CONSTRAINT PK_CATEGORIES1 PRIMARY KEY CLUSTERED 
  (
  CATEGORY
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE CUSTOMERS1 ADD CONSTRAINT PK_CUSTOMERS1 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_CUST_FG 
GO

CREATE UNIQUE INDEX IX_CUST_UN_PW1 ON CUSTOMERS1 
  (
  USERNAME, 
  PASSWORD
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID1 ON CUST_HIST1
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID1 ON CUST_HIST1 
  (
  CUSTOMERID ASC,
  PROD_ID ASC
  )
  ON DS_IND_FG
GO

ALTER TABLE CUST_HIST1
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID1 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS1 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE ORDERS1 ADD CONSTRAINT PK_ORDERS1 PRIMARY KEY CLUSTERED 
  (
  ORDERID
  )  
  ON DS_ORDERS_FG 
GO

CREATE INDEX IX_ORDER_CUSTID1 ON ORDERS1
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

ALTER TABLE ORDERLINES1 ADD CONSTRAINT PK_ORDERLINES1 PRIMARY KEY CLUSTERED 
  (
  ORDERID,
  ORDERLINEID
  )  
  ON DS_ORDERS_FG 
GO

ALTER TABLE ORDERLINES1 ADD CONSTRAINT FK_ORDERID1 FOREIGN KEY (ORDERID)
  REFERENCES ORDERS1 (ORDERID)
  ON DELETE CASCADE
GO

ALTER TABLE INVENTORY1 ADD CONSTRAINT PK_INVENTORY1 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE PRODUCTS1 ADD CONSTRAINT PK_PRODUCTS1 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

CREATE INDEX IX_PROD_PRODID1 ON PRODUCTS1 
  (
  PROD_ID ASC
  )
  INCLUDE (TITLE)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_PRODID_COMMON_PRODID1 ON PRODUCTS1
  (
  PROD_ID ASC,
  COMMON_PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL_CATEGORY_PRODID1 ON PRODUCTS1 
  (
  SPECIAL ASC,
  CATEGORY ASC,
  PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR, PRICE, COMMON_PROD_ID)
  ON DS_IND_FG
GO

CREATE FULLTEXT CATALOG FULLTEXT_DSPROD1 ON FILEGROUP DS_FULLTEXT_FG;
GO
CREATE FULLTEXT INDEX ON PRODUCTS1
	( 
	ACTOR,
	TITLE
	)
	KEY INDEX PK_PRODUCTS1 
	ON FULLTEXT_DSPROD1;
GO

CREATE INDEX IX_PROD_CATEGORY1 ON PRODUCTS1 
  (
  CATEGORY
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL1 ON PRODUCTS1
  (
  SPECIAL
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_MEMBERSHIP1 ON PRODUCTS1
  (
  MEMBERSHIP_ITEM
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_INV_PROD_ID1 on INVENTORY1
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

ALTER TABLE MEMBERSHIP1 ADD CONSTRAINT PK_MEMBERSHIP1 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_IND_FG 
GO

ALTER TABLE MEMBERSHIP1
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID1 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS1 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS1 ADD CONSTRAINT PK_REVIEWS1 PRIMARY KEY CLUSTERED 
  (
  REVIEW_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS1
  ADD CONSTRAINT FK_REVIEWS_PROD_ID1 FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS1 (PROD_ID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS1
  ADD CONSTRAINT FK_REVIEWS_CUSTOMERID1 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS1 (CUSTOMERID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_PROD_ID1 ON REVIEWS1
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_STARS1 ON REVIEWS1
  (
  STARS
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_PRODSTARS1 ON REVIEWS1
  (
  PROD_ID,STARS
  )
  ON DS_IND_FG
GO

ALTER TABLE REVIEWS_HELPFULNESS1 ADD CONSTRAINT PK_REVIEWS_HELPFULNESS1 PRIMARY KEY CLUSTERED 
  (
  REVIEW_HELPFULNESS_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS_HELPFULNESS1
  ADD CONSTRAINT FK_REVIEW_ID1 FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS1 (REVIEW_ID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_HELP_REVID1 ON REVIEWS_HELPFULNESS1
  (
  REVIEW_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_HELP_CUSTID1 ON REVIEWS_HELPFULNESS1
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REORDER_PRODID1 ON REORDER1
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE NONCLUSTERED INDEX IX_REVIEWS_PRODID_REVID_DATE1 ON REVIEWS1
  (
  PROD_ID ASC,
  REVIEW_ID ASC,
  REVIEW_DATE ASC
  )
  INCLUDE (STARS,CUSTOMERID,REVIEW_SUMMARY,REVIEW_TEXT)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go

CREATE NONCLUSTERED INDEX IX_REVIEWSHELPFULNESS_ID_HELPID1 ON [dbo].[REVIEWS_HELPFULNESS1]
  (
  REVIEW_ID ASC,
  REVIEW_HELPFULNESS_ID ASC
  )
  INCLUDE (HELPFULNESS)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go



CREATE STATISTICS stat_cust_cctype_username1 ON CUSTOMERS1(CREDITCARDTYPE, USERNAME)
GO
CREATE STATISTICS stat_cust_cctype_customerid1 ON CUSTOMERS1(CREDITCARDTYPE, CUSTOMERID)
GO
CREATE STATISTICS stat_prod_prodid_special1 ON PRODUCTS1(PROD_ID, SPECIAL)
GO
CREATE STATISTICS stat_prod_category_prodid1 ON PRODUCTS1(CATEGORY, PROD_ID)
GO
CREATE STATISTICS stat_reviews_reviewid_stars1 ON REVIEWS1(REVIEW_ID, STARS)
GO
CREATE STATISTICS stat_reviews_prodid_custid1 ON REVIEWS1(PROD_ID, CUSTOMERID)
GO
CREATE STATISTICS stat_reviews_reviewid_date1 ON REVIEWS1(REVIEW_ID, REVIEW_DATE)
GO
CREATE STATISTICS stat_reviews_date_prodid1 ON REVIEWS1(REVIEW_DATE, PROD_ID)
GO
CREATE STATISTICS stat_reviews_prodid_stars_reviewid1 ON REVIEWS1(PROD_ID, STARS, REVIEW_ID)
GO
  
