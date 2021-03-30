bcp ds3..orders5 in ..\..\..\data_files\orders\jan_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > jan_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\feb_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > feb_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\mar_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > mar_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\apr_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > apr_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\may_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > may_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\jun_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > jun_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\jul_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > jul_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\aug_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > aug_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\sep_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > sep_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\oct_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > oct_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\nov_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > nov_orders5.log
bcp ds3..orders5 in ..\..\..\data_files\orders\dec_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > dec_orders5.log
exit
