bcp ds3..membership18 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> membership18.log
time /T > finished18.txt
exit
