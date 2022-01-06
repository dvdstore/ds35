--logging out all users

SELECT pid, pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='ds3' AND pid <> pg_backend_pid();


