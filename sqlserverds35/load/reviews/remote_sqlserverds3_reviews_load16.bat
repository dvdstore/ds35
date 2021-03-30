bcp ds3..reviews16 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> reviews16.log
bcp ds3..reviews_helpfulness16 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> review_helpfulness16.log
time /T > finished16.txt
exit
