bcp ds3..reviews6 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> reviews6.log
bcp ds3..reviews_helpfulness6 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> review_helpfulness6.log
time /T > finished6.txt
exit
