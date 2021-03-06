USE DS3
GO

ALTER TABLE CATEGORIES11 ADD CONSTRAINT PK_CATEGORIES11 PRIMARY KEY CLUSTERED 
  (
  CATEGORY
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE CUSTOMERS11 ADD CONSTRAINT PK_CUSTOMERS11 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_CUST_FG 
GO

CREATE UNIQUE INDEX IX_CUST_UN_PW11 ON CUSTOMERS11 
  (
  USERNAME, 
  PASSWORD
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID11 ON CUST_HIST11
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID11 ON CUST_HIST11 
  (
  CUSTOMERID ASC,
  PROD_ID ASC
  )
  ON DS_IND_FG
GO

ALTER TABLE CUST_HIST11
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID11 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS11 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE ORDERS11 ADD CONSTRAINT PK_ORDERS11 PRIMARY KEY CLUSTERED 
  (
  ORDERID
  )  
  ON DS_ORDERS_FG 
GO

CREATE INDEX IX_ORDER_CUSTID11 ON ORDERS11
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

ALTER TABLE ORDERLINES11 ADD CONSTRAINT PK_ORDERLINES11 PRIMARY KEY CLUSTERED 
  (
  ORDERID,
  ORDERLINEID
  )  
  ON DS_ORDERS_FG 
GO

ALTER TABLE ORDERLINES11 ADD CONSTRAINT FK_ORDERID11 FOREIGN KEY (ORDERID)
  REFERENCES ORDERS11 (ORDERID)
  ON DELETE CASCADE
GO

ALTER TABLE INVENTORY11 ADD CONSTRAINT PK_INVENTORY11 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE PRODUCTS11 ADD CONSTRAINT PK_PRODUCTS11 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

CREATE INDEX IX_PROD_PRODID11 ON PRODUCTS11 
  (
  PROD_ID ASC
  )
  INCLUDE (TITLE)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_PRODID_COMMON_PRODID11 ON PRODUCTS11
  (
  PROD_ID ASC,
  COMMON_PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL_CATEGORY_PRODID11 ON PRODUCTS11 
  (
  SPECIAL ASC,
  CATEGORY ASC,
  PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR, PRICE, COMMON_PROD_ID)
  ON DS_IND_FG
GO

CREATE FULLTEXT CATALOG FULLTEXT_DSPROD11 ON FILEGROUP DS_FULLTEXT_FG;
GO
CREATE FULLTEXT INDEX ON PRODUCTS11
	( 
	ACTOR,
	TITLE
	)
	KEY INDEX PK_PRODUCTS11 
	ON FULLTEXT_DSPROD11;
GO

CREATE INDEX IX_PROD_CATEGORY11 ON PRODUCTS11 
  (
  CATEGORY
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL11 ON PRODUCTS11
  (
  SPECIAL
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_MEMBERSHIP11 ON PRODUCTS11
  (
  MEMBERSHIP_ITEM
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_INV_PROD_ID11 on INVENTORY11
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

ALTER TABLE MEMBERSHIP11 ADD CONSTRAINT PK_MEMBERSHIP11 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_IND_FG 
GO

ALTER TABLE MEMBERSHIP11
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID11 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS11 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS11 ADD CONSTRAINT PK_REVIEWS11 PRIMARY KEY CLUSTERED 
  (
  REVIEW_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS11
  ADD CONSTRAINT FK_REVIEWS_PROD_ID11 FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS11 (PROD_ID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS11
  ADD CONSTRAINT FK_REVIEWS_CUSTOMERID11 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS11 (CUSTOMERID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_PROD_ID11 ON REVIEWS11
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_STARS11 ON REVIEWS11
  (
  STARS
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_PRODSTARS11 ON REVIEWS11
  (
  PROD_ID,STARS
  )
  ON DS_IND_FG
GO

ALTER TABLE REVIEWS_HELPFULNESS11 ADD CONSTRAINT PK_REVIEWS_HELPFULNESS11 PRIMARY KEY CLUSTERED 
  (
  REVIEW_HELPFULNESS_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS_HELPFULNESS11
  ADD CONSTRAINT FK_REVIEW_ID11 FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS11 (REVIEW_ID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_HELP_REVID11 ON REVIEWS_HELPFULNESS11
  (
  REVIEW_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_HELP_CUSTID11 ON REVIEWS_HELPFULNESS11
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REORDER_PRODID11 ON REORDER11
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE NONCLUSTERED INDEX IX_REVIEWS_PRODID_REVID_DATE11 ON REVIEWS11
  (
  PROD_ID ASC,
  REVIEW_ID ASC,
  REVIEW_DATE ASC
  )
  INCLUDE (STARS,CUSTOMERID,REVIEW_SUMMARY,REVIEW_TEXT)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go

CREATE NONCLUSTERED INDEX IX_REVIEWSHELPFULNESS_ID_HELPID11 ON [dbo].[REVIEWS_HELPFULNESS11]
  (
  REVIEW_ID ASC,
  REVIEW_HELPFULNESS_ID ASC
  )
  INCLUDE (HELPFULNESS)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go



CREATE STATISTICS stat_cust_cctype_username11 ON CUSTOMERS11(CREDITCARDTYPE, USERNAME)
GO
CREATE STATISTICS stat_cust_cctype_customerid11 ON CUSTOMERS11(CREDITCARDTYPE, CUSTOMERID)
GO
CREATE STATISTICS stat_prod_prodid_special11 ON PRODUCTS11(PROD_ID, SPECIAL)
GO
CREATE STATISTICS stat_prod_category_prodid11 ON PRODUCTS11(CATEGORY, PROD_ID)
GO
CREATE STATISTICS stat_reviews_reviewid_stars11 ON REVIEWS11(REVIEW_ID, STARS)
GO
CREATE STATISTICS stat_reviews_prodid_custid11 ON REVIEWS11(PROD_ID, CUSTOMERID)
GO
CREATE STATISTICS stat_reviews_reviewid_date11 ON REVIEWS11(REVIEW_ID, REVIEW_DATE)
GO
CREATE STATISTICS stat_reviews_date_prodid11 ON REVIEWS11(REVIEW_DATE, PROD_ID)
GO
CREATE STATISTICS stat_reviews_prodid_stars_reviewid11 ON REVIEWS11(PROD_ID, STARS, REVIEW_ID)
GO
  
