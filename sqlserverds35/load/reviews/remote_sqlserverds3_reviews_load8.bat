bcp ds3..reviews8 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> reviews8.log
bcp ds3..reviews_helpfulness8 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> review_helpfulness8.log
time /T > finished8.txt
exit
