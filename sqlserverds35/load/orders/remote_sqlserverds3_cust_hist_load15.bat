bcp ds3..cust_hist15 in ..\..\..\data_files\orders\jan_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> jan_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\feb_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> feb_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\mar_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> mar_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\apr_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> apr_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\may_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> may_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\jun_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> jun_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\jul_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> jul_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\aug_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> aug_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\sep_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> sep_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\oct_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> oct_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\nov_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> nov_cust_hist15.log
bcp ds3..cust_hist15 in ..\..\..\data_files\orders\dec_cust_hist.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> dec_cust_hist15.log
time /T > finished15.txt
exit
