bcp ds3..orders1 in ..\..\..\data_files\orders\jan_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > jan_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\feb_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > feb_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\mar_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > mar_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\apr_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > apr_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\may_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > may_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\jun_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > jun_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\jul_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > jul_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\aug_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > aug_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\sep_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > sep_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\oct_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > oct_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\nov_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > nov_orders1.log
bcp ds3..orders1 in ..\..\..\data_files\orders\dec_orders.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > dec_orders1.log
exit
