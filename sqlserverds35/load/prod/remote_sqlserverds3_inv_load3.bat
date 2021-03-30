bcp ds3..inventory3 in ..\..\..\data_files\prod\inv.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> inv3.log
exit
