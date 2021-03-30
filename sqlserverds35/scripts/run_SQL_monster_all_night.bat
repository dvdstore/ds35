REM - First make sure that the SSL key is cached correctly by doing a quick ls against the ESX host so that scripted esxtop will work
plink root@10.115.152.96 ls
REM -- Run tests
REM -- delay time for VMs to be up and running
sleep 900
perl ds3sqlsrv_AMD_run_and_parse_results_8instances.pl 16vCPUs_8vms_AMD_local_2K19_16drivers_2inst_5stores_daytona21_NewFirmWare_67u3p01_resetDB_NPS2ccxnuma_run1
sleep 120
REM -- Run tests
perl ds3sqlsrv_AMD_run_and_parse_results_8instances.pl 16vCPUs_8vms_AMD_local_2K19_16drivers_2inst_5stores_daytona21_NewFirmWare_67u3p01_resetDB_NPS2ccxnuma_run2
sleep 120
REM -- Run tests
perl ds3sqlsrv_AMD_run_and_parse_results_8instances.pl 16vCPUs_8vms_AMD_local_2K19_16drivers_2inst_5stores_daytona21_NewFirmWare_67u3p01_resetDB_NPS2ccxnuma_run3
REM sleep 120
REM -- Run tests
REM perl ds3sqlsrv_AMD_run_and_parse_results_8instances.pl 16vCPUs_8vms_AMD_local_2K19_16drivers_2inst_5stores_daytona21_NewFirmWare_67u3p01_NPS2ccxnuma_run4
REM sleep 120
REM -- Run tests
REM perl ds3sqlsrv_AMD_run_and_parse_results_8instances.pl 16vCPUs_8vms_AMD_local_2K19_16drivers_2inst_5stores_daytona21_NewFirmWare_67u3p01_NPS2ccxnuma_run5
REM sleep 120
REM -- Run tests
REM perl ds3sqlsrv_AMD_run_and_parse_results_8instances.pl 16vCPUs_8vms_AMD_local_2K19_16drivers_2inst_5stores_daytona21_NewFirmWare_67u3p01_NPS2ccxnuma_run6