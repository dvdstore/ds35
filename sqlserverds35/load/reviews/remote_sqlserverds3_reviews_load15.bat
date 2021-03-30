bcp ds3..reviews15 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> reviews15.log
bcp ds3..reviews_helpfulness15 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> review_helpfulness15.log
time /T > finished15.txt
exit
