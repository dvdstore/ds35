-- DS3 Database Build Scripts
-- Dave Jaffe  Todd Muirhead 8/31/05
-- Copyright Dell Inc. 2005

-- User

SET TERMOUT OFF
DROP USER DS3 CASCADE;
SET TERMOUT ON

CREATE USER DS3
  IDENTIFIED BY ds3
  TEMPORARY TABLESPACE "TEMP"
  DEFAULT TABLESPACE "DS_MISC"
  ;

GRANT CONNECT, RESOURCE TO "DS3";

ALTER user DS3 quota unlimited on DS_MISC;
ALTER user DS3 quota unlimited on CUSTTBS;
ALTER user DS3 quota unlimited on INDXTBS;
ALTER user DS3 quota unlimited on ORDERTBS;
ALTER user DS3 quota unlimited on REVIEWTBS;
ALTER user DS3 quota unlimited on MEMBERTBS;

EXIT;