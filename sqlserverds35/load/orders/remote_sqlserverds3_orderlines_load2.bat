bcp ds3..orderlines2 in ..\..\..\data_files\orders\jan_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> jan_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\feb_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> feb_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\mar_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> mar_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\apr_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> apr_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\may_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> may_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\jun_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> jun_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\jul_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> jul_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\aug_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> aug_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\sep_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> sep_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\oct_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> oct_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\nov_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> nov_orderlines2.log
bcp ds3..orderlines2 in ..\..\..\data_files\orders\dec_orderlines.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> dec_orderlines2.log
exit
