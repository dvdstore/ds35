\c ds3;

ALTER TABLE CUSTOMERS1 DISABLE TRIGGER ALL;

\COPY CUSTOMERS1 FROM '..\\..\\..\\data_files\\cust\\us_cust.csv' WITH DELIMITER ','
\COPY CUSTOMERS1 FROM '..\\..\\..\\data_files\\cust\\row_cust.csv' WITH DELIMITER ','

ALTER TABLE CUSTOMERS1 ENABLE TRIGGER ALL;

