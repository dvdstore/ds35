bcp ds3..reviews3 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> reviews3.log
bcp ds3..reviews_helpfulness3 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> review_helpfulness3.log
time /T > finished3.txt
exit
