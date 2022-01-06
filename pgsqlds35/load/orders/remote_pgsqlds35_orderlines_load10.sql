\c ds3;

ALTER TABLE ORDERLINES10 DISABLE TRIGGER ALL;

\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\jan_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\feb_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\mar_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\apr_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\may_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\jun_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\jul_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\aug_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\sep_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\oct_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\nov_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES10 FROM '..\\..\\..\\data_files\\orders\\dec_orderlines.csv' WITH DELIMITER ','

ALTER TABLE ORDERLINES10 ENABLE TRIGGER ALL;


