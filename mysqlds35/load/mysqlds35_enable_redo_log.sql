/* mysqlds35_edable_redo_log.sql TM 11-8-21*/
/* Checks to see if version is above 8.00.21 when the ability to disable redo logs was added */
/* Then enables the redo log after bulk loading is complete*/
/*!80021 ALTER INSTANCE ENABLE INNODB REDO_LOG*/;