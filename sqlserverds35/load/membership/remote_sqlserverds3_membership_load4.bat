bcp ds3..membership4 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> membership4.log
time /T > finished4.txt
exit
