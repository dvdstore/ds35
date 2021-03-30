bcp ds3..membership2 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> membership2.log
time /T > finished2.txt
exit
