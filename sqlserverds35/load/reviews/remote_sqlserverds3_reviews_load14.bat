bcp ds3..reviews14 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> reviews14.log
bcp ds3..reviews_helpfulness14 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> review_helpfulness14.log
time /T > finished14.txt
exit
