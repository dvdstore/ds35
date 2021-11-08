/* mysqlds35_disable_redo_log.sql TM 11-8-21*/
/* Checks to see if version is above 8.00.21 when the ability to disable redo logs was added */
/* Then disables the redo log for the purposes of bulk loading */
/*!80021 ALTER INSTANCE DISABLE INNODB REDO_LOG*/;