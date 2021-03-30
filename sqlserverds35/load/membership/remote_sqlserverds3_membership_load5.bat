bcp ds3..membership5 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> membership5.log
time /T > finished5.txt
exit
