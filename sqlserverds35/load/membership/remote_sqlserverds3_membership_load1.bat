bcp ds3..membership1 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> membership1.log
time /T > finished1.txt
exit
