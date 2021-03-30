bcp ds3..membership14 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> membership14.log
time /T > finished14.txt
exit
