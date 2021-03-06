-- DS3 Database Build Scripts
-- Dave Jaffe  Todd Muirhead 8/31/05
-- Copyright Dell Inc. 2005

-- Data types

CREATE OR REPLACE  PACKAGE "DS3"."DS3_TYPES"  AS
  TYPE DS3_CURSOR IS REF CURSOR;
  TYPE ARRAY_TYPE IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
  TYPE LONG_ARRAY_TYPE IS TABLE OF VARCHAR2(1000) INDEX BY BINARY_INTEGER;
  TYPE N_TYPE IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
END DS3_TYPES;
/

COMMIT;

EXIT;