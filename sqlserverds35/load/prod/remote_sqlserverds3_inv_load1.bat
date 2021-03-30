bcp ds3..inventory1 in ..\..\..\data_files\prod\inv.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> inv1.log
exit
