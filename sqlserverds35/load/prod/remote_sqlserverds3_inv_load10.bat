bcp ds3..inventory10 in ..\..\..\data_files\prod\inv.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> inv10.log
exit
