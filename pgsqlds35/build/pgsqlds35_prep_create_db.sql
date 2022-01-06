-- pgsqlds35_prep_create_db.sql: DVD Store Database version 3.5 build script - PostgresQL verson
-- <lalvarezsanc@vmware.com>
-- Last updated 11/1/21

-- Database

DROP DATABASE IF EXISTS DS3;
CREATE DATABASE DS3;
DROP USER IF EXISTS DS3;
CREATE USER DS3 WITH SUPERUSER;
ALTER USER DS3 WITH PASSWORD 'ds3';
