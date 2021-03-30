REM - First make sure that the SSL key is cached correctly by doing a quick ls against the ESX host so that scripted esxtop will work
plink root@w2-bdperf2-001 ls
REM - Rebuild database instances
call .\build_all_2dbs.bat
REM -- Run tests
REM -- delay time for VMs to be up and running
sleep 300
REM perl ds35vSAN_nvme_run_and_parse_results.pl nvme_16vCPU_2instances_SQL_rebuild_16GBdbcache_CandDdisabled_autotest4
REM sleep 120
perl ds35vSAN_pvscsi_run_and_parse_results.pl pvscsi_16vCPU_2instances_SQL_rebuild_16GBdbcache_pvscsi256Q_CandDdisabled_autotest1
sleep 120
REM - Rebuild database instances
call .\build_all_2dbs.bat
REM -- Run tests
REM -- delay time for VMs to be up and running
sleep 300
REM perl ds35vSAN_nvme_run_and_parse_results.pl nvme_16vCPU_2instances_SQL_rebuild_16GBdbcache_CandDdisabled_autotest5
REM sleep 120
perl ds35vSAN_pvscsi_run_and_parse_results.pl pvscsi_16vCPU_2instances_SQL_rebuild_16GBdbcache_pvscsi256Q_CandDdisabled_autotest2
sleep 120
REM - Rebuild database instances
call .\build_all_2dbs.bat
REM -- Run tests
REM -- delay time for VMs to be up and running
sleep 300
REM perl ds35vSAN_nvme_run_and_parse_results.pl nvme_16vCPU_2instances_SQL_rebuild_16GBdbcache_CandDdisabled_autotest3
REM sleep 120
perl ds35vSAN_pvscsi_run_and_parse_results.pl pvscsi_16vCPU_2instances_SQL_rebuild_16GBdbcache_pvscsi256Q_CandDdisabled_autotest3
sleep 120