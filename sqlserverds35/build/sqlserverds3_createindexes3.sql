USE DS3
GO

ALTER TABLE CATEGORIES3 ADD CONSTRAINT PK_CATEGORIES3 PRIMARY KEY CLUSTERED 
  (
  CATEGORY
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE CUSTOMERS3 ADD CONSTRAINT PK_CUSTOMERS3 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_CUST_FG 
GO

CREATE UNIQUE INDEX IX_CUST_UN_PW3 ON CUSTOMERS3 
  (
  USERNAME, 
  PASSWORD
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID3 ON CUST_HIST3
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID3 ON CUST_HIST3 
  (
  CUSTOMERID ASC,
  PROD_ID ASC
  )
  ON DS_IND_FG
GO

ALTER TABLE CUST_HIST3
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID3 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS3 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE ORDERS3 ADD CONSTRAINT PK_ORDERS3 PRIMARY KEY CLUSTERED 
  (
  ORDERID
  )  
  ON DS_ORDERS_FG 
GO

CREATE INDEX IX_ORDER_CUSTID3 ON ORDERS3
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

ALTER TABLE ORDERLINES3 ADD CONSTRAINT PK_ORDERLINES3 PRIMARY KEY CLUSTERED 
  (
  ORDERID,
  ORDERLINEID
  )  
  ON DS_ORDERS_FG 
GO

ALTER TABLE ORDERLINES3 ADD CONSTRAINT FK_ORDERID3 FOREIGN KEY (ORDERID)
  REFERENCES ORDERS3 (ORDERID)
  ON DELETE CASCADE
GO

ALTER TABLE INVENTORY3 ADD CONSTRAINT PK_INVENTORY3 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE PRODUCTS3 ADD CONSTRAINT PK_PRODUCTS3 PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

CREATE INDEX IX_PROD_PRODID3 ON PRODUCTS3 
  (
  PROD_ID ASC
  )
  INCLUDE (TITLE)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_PRODID_COMMON_PRODID3 ON PRODUCTS3
  (
  PROD_ID ASC,
  COMMON_PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL_CATEGORY_PRODID3 ON PRODUCTS3 
  (
  SPECIAL ASC,
  CATEGORY ASC,
  PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR, PRICE, COMMON_PROD_ID)
  ON DS_IND_FG
GO

CREATE FULLTEXT CATALOG FULLTEXT_DSPROD3 ON FILEGROUP DS_FULLTEXT_FG;
GO
CREATE FULLTEXT INDEX ON PRODUCTS3
	( 
	ACTOR,
	TITLE
	)
	KEY INDEX PK_PRODUCTS3 
	ON FULLTEXT_DSPROD3;
GO

CREATE INDEX IX_PROD_CATEGORY3 ON PRODUCTS3 
  (
  CATEGORY
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL3 ON PRODUCTS3
  (
  SPECIAL
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_MEMBERSHIP3 ON PRODUCTS3
  (
  MEMBERSHIP_ITEM
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_INV_PROD_ID3 on INVENTORY3
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

ALTER TABLE MEMBERSHIP3 ADD CONSTRAINT PK_MEMBERSHIP3 PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_IND_FG 
GO

ALTER TABLE MEMBERSHIP3
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID3 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS3 (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS3 ADD CONSTRAINT PK_REVIEWS3 PRIMARY KEY CLUSTERED 
  (
  REVIEW_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS3
  ADD CONSTRAINT FK_REVIEWS_PROD_ID3 FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS3 (PROD_ID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS3
  ADD CONSTRAINT FK_REVIEWS_CUSTOMERID3 FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS3 (CUSTOMERID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_PROD_ID3 ON REVIEWS3
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_STARS3 ON REVIEWS3
  (
  STARS
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_PRODSTARS3 ON REVIEWS3
  (
  PROD_ID,STARS
  )
  ON DS_IND_FG
GO

ALTER TABLE REVIEWS_HELPFULNESS3 ADD CONSTRAINT PK_REVIEWS_HELPFULNESS3 PRIMARY KEY CLUSTERED 
  (
  REVIEW_HELPFULNESS_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS_HELPFULNESS3
  ADD CONSTRAINT FK_REVIEW_ID3 FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS3 (REVIEW_ID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_HELP_REVID3 ON REVIEWS_HELPFULNESS3
  (
  REVIEW_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_HELP_CUSTID3 ON REVIEWS_HELPFULNESS3
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REORDER_PRODID3 ON REORDER3
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE NONCLUSTERED INDEX IX_REVIEWS_PRODID_REVID_DATE3 ON REVIEWS3
  (
  PROD_ID ASC,
  REVIEW_ID ASC,
  REVIEW_DATE ASC
  )
  INCLUDE (STARS,CUSTOMERID,REVIEW_SUMMARY,REVIEW_TEXT)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go

CREATE NONCLUSTERED INDEX IX_REVIEWSHELPFULNESS_ID_HELPID3 ON [dbo].[REVIEWS_HELPFULNESS3]
  (
  REVIEW_ID ASC,
  REVIEW_HELPFULNESS_ID ASC
  )
  INCLUDE (HELPFULNESS)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go



CREATE STATISTICS stat_cust_cctype_username3 ON CUSTOMERS3(CREDITCARDTYPE, USERNAME)
GO
CREATE STATISTICS stat_cust_cctype_customerid3 ON CUSTOMERS3(CREDITCARDTYPE, CUSTOMERID)
GO
CREATE STATISTICS stat_prod_prodid_special3 ON PRODUCTS3(PROD_ID, SPECIAL)
GO
CREATE STATISTICS stat_prod_category_prodid3 ON PRODUCTS3(CATEGORY, PROD_ID)
GO
CREATE STATISTICS stat_reviews_reviewid_stars3 ON REVIEWS3(REVIEW_ID, STARS)
GO
CREATE STATISTICS stat_reviews_prodid_custid3 ON REVIEWS3(PROD_ID, CUSTOMERID)
GO
CREATE STATISTICS stat_reviews_reviewid_date3 ON REVIEWS3(REVIEW_ID, REVIEW_DATE)
GO
CREATE STATISTICS stat_reviews_date_prodid3 ON REVIEWS3(REVIEW_DATE, PROD_ID)
GO
CREATE STATISTICS stat_reviews_prodid_stars_reviewid3 ON REVIEWS3(PROD_ID, STARS, REVIEW_ID)
GO
  
