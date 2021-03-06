USE DS3
GO

ALTER TABLE CATEGORIES17 ADD CONSTRAINT PK_CATEGORIES17 PRIMARY KEY CLUSTERED 
  (
  CATEGORY
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE CUSTOMERS17 ADD CONSTRAINT PK_CUSTOMERS17 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_CUST_FG 
GO

CREATE UNIQUE INDEX IX_CUST_UN_PW17 ON CUSTOMERS17 
  (
  USERNAME, 
  PASSWORD
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID17 ON CUST_HIST17
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID17 ON CUST_HIST17 
  (
  CUSTOMERID ASC,
  PROD_ID ASC
  )
  ON DS_IND_FG
GO

ALTER TABLE CUST_HIST17
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID17 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS17 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE ORDERS17 ADD CONSTRAINT PK_ORDERS17 PRIMARY KEY CLUSTERED 
  (
  ORDERID
  )  
  ON DS_ORDERS_FG 
GO

CREATE INDEX IX_ORDER_CUSTID17 ON ORDERS17
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

ALTER TABLE ORDERLINES17 ADD CONSTRAINT PK_ORDERLINES17 PRIMARY KEY CLUSTERED 
  (
  ORDERID,
  ORDERLINEID
  )  
  ON DS_ORDERS_FG 
GO

ALTER TABLE ORDERLINES17 ADD CONSTRAINT FK_ORDERID17 FOREIGN KEY (ORDERID)
  REFERENCES ORDERS17 (ORDERID)
  ON DELETE CASCADE
GO

ALTER TABLE INVENTORY17 ADD CONSTRAINT PK_INVENTORY17 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE PRODUCTS17 ADD CONSTRAINT PK_PRODUCTS17 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

CREATE INDEX IX_PROD_PRODID17 ON PRODUCTS17 
  (
  PROD_ID ASC
  )
  INCLUDE (TITLE)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_PRODID_COMMON_PRODID17 ON PRODUCTS17
  (
  PROD_ID ASC,
  COMMON_PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL_CATEGORY_PRODID17 ON PRODUCTS17 
  (
  SPECIAL ASC,
  CATEGORY ASC,
  PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR, PRICE, COMMON_PROD_ID)
  ON DS_IND_FG
GO

CREATE FULLTEXT CATALOG FULLTEXT_DSPROD17 ON FILEGROUP DS_FULLTEXT_FG;
GO
CREATE FULLTEXT INDEX ON PRODUCTS17
	( 
	ACTOR,
	TITLE
	)
	KEY INDEX PK_PRODUCTS17 
	ON FULLTEXT_DSPROD17;
GO

CREATE INDEX IX_PROD_CATEGORY17 ON PRODUCTS17 
  (
  CATEGORY
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL17 ON PRODUCTS17
  (
  SPECIAL
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_MEMBERSHIP17 ON PRODUCTS17
  (
  MEMBERSHIP_ITEM
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_INV_PROD_ID17 on INVENTORY17
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

ALTER TABLE MEMBERSHIP17 ADD CONSTRAINT PK_MEMBERSHIP17 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_IND_FG 
GO

ALTER TABLE MEMBERSHIP17
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID17 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS17 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS17 ADD CONSTRAINT PK_REVIEWS17 PRIMARY KEY CLUSTERED 
  (
  REVIEW_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS17
  ADD CONSTRAINT FK_REVIEWS_PROD_ID17 FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS17 (PROD_ID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS17
  ADD CONSTRAINT FK_REVIEWS_CUSTOMERID17 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS17 (CUSTOMERID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_PROD_ID17 ON REVIEWS17
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_STARS17 ON REVIEWS17
  (
  STARS
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_PRODSTARS17 ON REVIEWS17
  (
  PROD_ID,STARS
  )
  ON DS_IND_FG
GO

ALTER TABLE REVIEWS_HELPFULNESS17 ADD CONSTRAINT PK_REVIEWS_HELPFULNESS17 PRIMARY KEY CLUSTERED 
  (
  REVIEW_HELPFULNESS_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS_HELPFULNESS17
  ADD CONSTRAINT FK_REVIEW_ID17 FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS17 (REVIEW_ID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_HELP_REVID17 ON REVIEWS_HELPFULNESS17
  (
  REVIEW_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_HELP_CUSTID17 ON REVIEWS_HELPFULNESS17
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REORDER_PRODID17 ON REORDER17
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE NONCLUSTERED INDEX IX_REVIEWS_PRODID_REVID_DATE17 ON REVIEWS17
  (
  PROD_ID ASC,
  REVIEW_ID ASC,
  REVIEW_DATE ASC
  )
  INCLUDE (STARS,CUSTOMERID,REVIEW_SUMMARY,REVIEW_TEXT)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go

CREATE NONCLUSTERED INDEX IX_REVIEWSHELPFULNESS_ID_HELPID17 ON [dbo].[REVIEWS_HELPFULNESS17]
  (
  REVIEW_ID ASC,
  REVIEW_HELPFULNESS_ID ASC
  )
  INCLUDE (HELPFULNESS)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go



CREATE STATISTICS stat_cust_cctype_username17 ON CUSTOMERS17(CREDITCARDTYPE, USERNAME)
GO
CREATE STATISTICS stat_cust_cctype_customerid17 ON CUSTOMERS17(CREDITCARDTYPE, CUSTOMERID)
GO
CREATE STATISTICS stat_prod_prodid_special17 ON PRODUCTS17(PROD_ID, SPECIAL)
GO
CREATE STATISTICS stat_prod_category_prodid17 ON PRODUCTS17(CATEGORY, PROD_ID)
GO
CREATE STATISTICS stat_reviews_reviewid_stars17 ON REVIEWS17(REVIEW_ID, STARS)
GO
CREATE STATISTICS stat_reviews_prodid_custid17 ON REVIEWS17(PROD_ID, CUSTOMERID)
GO
CREATE STATISTICS stat_reviews_reviewid_date17 ON REVIEWS17(REVIEW_ID, REVIEW_DATE)
GO
CREATE STATISTICS stat_reviews_date_prodid17 ON REVIEWS17(REVIEW_DATE, PROD_ID)
GO
CREATE STATISTICS stat_reviews_prodid_stars_reviewid17 ON REVIEWS17(PROD_ID, STARS, REVIEW_ID)
GO
  
